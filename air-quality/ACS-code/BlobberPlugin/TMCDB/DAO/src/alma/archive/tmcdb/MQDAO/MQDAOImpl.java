/*******************************************************************************
 * ALMA - Atacama Large Millimeter Array
 * Copyright (c) AUI - Associated Universities Inc., 2011
 * (in the framework of the ALMA collaboration).
 * All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License aInteger with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
 *******************************************************************************/
package alma.archive.tmcdb.MQDAO;
import java.util.Date;




import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.HashSet;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.TimeUnit;
import java.lang.reflect.Constructor;
import java.lang.InterruptedException;
import org.influxdb.InfluxDB;
import org.influxdb.dto.BatchPoints;
import org.influxdb.dto.Point;
import org.influxdb.dto.Pong;
import org.influxdb.InfluxDBFactory;
import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Session;
import javax.jms.Topic;
import javax.jms.TopicConnection;
import javax.jms.TopicPublisher;
import javax.jms.TopicSession;

import org.apache.activemq.ActiveMQConnectionFactory;

import alma.DAOErrType.wrappers.AcsJDBConnectionFailureEx;
import alma.JavaContainerError.wrappers.AcsJContainerServicesEx;
import alma.ACSErrTypeCommon.wrappers.AcsJCouldntCreateObjectEx;
import alma.acs.logging.AcsLogLevel;
import alma.acs.container.ContainerServices;
import alma.acs.concurrent.NamedThreadFactory;
import alma.acs.monitoring.DAO.ComponentData;
import alma.acs.monitoring.DAO.MonitorDAO;
import alma.acs.monitoring.blobber.BlobberWatchDog;
import alma.archive.tmcdb.persistence.TMCDBConfig;
import example.Telegram.telegramalarm;
import example.Telegram.telegramalarmHelper;
import alma.ACS.ComponentStates;
import alma.acs.component.ComponentLifecycle;

import example.Hello.helloworld;
import example.Hello.helloworldHelper;

@SuppressWarnings("deprecation")
public class MQDAOImpl implements MonitorDAO
{
	private ContainerServices containerServices;
	private Logger log;

	private LinkedBlockingQueue<ComponentData> myMQDataQueue;
	private final BlobConsumer myBlobConsumer;
        private final ExecutorService blobConsumerExecutor;
	//private Thread myBlobConsumerThread = null;
	private final HashSet<String> simulatedAntennaHashSet;
	private ContainerServices m_containerServices;
	private telegramalarm alarm_Component;
	// MQ attributes
	private String location;
	private String broker_url;
	private String topic_name;
	private TopicConnection topicConnection;
	private TopicSession topicSession;
	private TopicPublisher topicPublisher;
	private boolean mqEnabled = false;
	private boolean mqConnected = false;

	private InfluxDB influxDB;
	private String influx_url;

    /** The retention policy name */
    private String aRetentionPolicy;
    private Long rectifyTime;
    private Long last_time;
    /** The influxdb user */
    private String influx_user;

    /** The influxdb password */
	 private String influx_password;
	 private String[] clobArrayTime;



	public MQDAOImpl(ContainerServices cs, BlobberWatchDog watchDog) {
		this.containerServices = cs;
		this.log = cs.getLogger();

		TMCDBConfig config = TMCDBConfig.getInstance(log);
		mqEnabled = config.isBrokerEnabled();
		broker_url = config.getBrokerURL();
		topic_name = config.getTopic();


this.influx_url = config.getInfluxURL();
	this.aRetentionPolicy = config.getRetentionPolicy();
	this.influx_user = config.getInfluxUser();
	this.influx_password = config.getInfluxPassword();
	this.rectifyTime = config.getRectifyTime();

setInfluxDBConnection(this.influx_url, this.influx_user, this.influx_password);
	setInfluxDBDatabase(topic_name);
	setInfluxDBRetentionPolicy(this.aRetentionPolicy);

		log.info("This mqDAO will use the following settings for storing data: "
			+ "mqstore_enabled=" + mqEnabled
			+ ", broker_url=" + broker_url
			+ ", topic=" + topic_name);
		m_containerServices = containerServices;
		try {
		
			org.omg.CORBA.Object alarmComponent = m_containerServices.getComponent("TelegramAlarm");

			alarm_Component = telegramalarmHelper.narrow(alarmComponent);
			
			

			if (alarmComponent == null) {
				throw new AcsJContainerServicesEx();
			}
			

			} catch (AcsJContainerServicesEx e) {
				e.printStackTrace();
			}
		HashSet<String> tmpSimulatedAntennaHashSet = config.getAntennaSimulatedSet(); // need this to allow declaring simulatedAntennaHashSet as final field
		if (tmpSimulatedAntennaHashSet == null) {
			simulatedAntennaHashSet = new HashSet<String>(1);
			simulatedAntennaHashSet.add("NONE");
			log.info("No simulated antennas on current deployment.");
		} else {
			simulatedAntennaHashSet = tmpSimulatedAntennaHashSet;
			for (Object simulatedAntennaName : simulatedAntennaHashSet) {
				log.info("Simulated antenna '" + (String) simulatedAntennaName + "' detected. No monitoring info coming from this antenna will be persisted to TMC");
			}
		}

		myMQDataQueue = new LinkedBlockingQueue<ComponentData>(100000);
		watchDog.addQueueToWatch(myMQDataQueue, "mq", 100000);

		//this.myBlobConsumer = new BlobConsumer();
		ThreadFactory tf = new NamedThreadFactory(containerServices.getThreadFactory(), "MQBlobConsumerThread");
		blobConsumerExecutor = Executors.newSingleThreadExecutor(tf);
		myBlobConsumer = new BlobConsumer();
		blobConsumerExecutor.execute(myBlobConsumer);

	}

    public void setInfluxDBConnection(String influx_url, String influx_user, String influx_password) {
        this.influxDB = InfluxDBFactory.connect(influx_url, influx_user, influx_password);	
	
    }

    /**
 *      * Set InfluxDB database
 *           *
 *                * If the database does not exist it is possible to create it, but there are problems with the retention policy
 *                     */

    public void setInfluxDBDatabase(String influx_dbname){
	boolean checkDbExistence = influxDB.databaseExists(influx_dbname);
	if (!checkDbExistence)
		influxDB.createDatabase(influx_dbname);
	this.influxDB.setDatabase(influx_dbname);
    }

    /**
 *      * Set InfluxDB retention policy
 *           *
 *                */

    public void setInfluxDBRetentionPolicy(String aRetentionPolicy){
	this.influxDB.setRetentionPolicy(aRetentionPolicy);
    }


	public void store(ComponentData inData) throws Exception {
		myMQDataQueue.put(inData);
	}

	/**
	 * Sends data over JMS to the TMCDumper
	 * <p>
	 * Really needed are <code>inData.startTime</code>, <code>inData.componentName</code>, 
	 * <code>inData.index</code>, <code>inData.clob</code>.
	 * <p>
	 * The consumer side code is under ADC/SW/TMCDB/TMC-WS.
	 */
	private void mqStore(ComponentData inData, ComponentData inData2) throws Exception {
		if (!mqEnabled || !mqConnected)
			return;

		// We skip monitoring information coming from simulated antennas
		/*if ( simulatedAntennaHashSet.contains((inData.componentName.split("/"))[1]) ) {
			if ( log.isLoggable(Level.FINER) )
				log.finer("Dropping blob data for " + inData.componentName.split("/")[1] + ":" + inData.propertyPathname());
			return;
		}

		if ( log.isLoggable(Level.FINE) )
			log.fine("Handling blob for component/property: " + inData.toString());
			//log.fine("publishNewMonitorData Called: CompName:" + inData.componentName + ", propName: " + inData.propertyName + ", index: " + inData.index);
*/
		try {

	BatchPoints batchPoints = BatchPoints.database(this.topic_name).tag("async", "true").retentionPolicy(this.aRetentionPolicy).build();
		String[] clobArray = inData.getClob().replaceAll("\n", "|").split("\\|");
		if(inData2 != null){
				this.clobArrayTime = inData2.getClob().replaceAll("\n", "|").split("\\|");	
		}else{
			this.clobArrayTime = null;
		}
for (int i=0; i<clobArray.length-1; i+=2) {

long time_value = ((Long.parseLong(clobArray[i]) - rectifyTime)/100000);
if(inData2 != null){
	time_value = Long.parseLong(clobArrayTime[i+1]) * 1000;
	
}
System.out.println(inData.propertyName);
System.out.println(time_value);
System.out.println(""+time_value);
if (alarm_Component != null) {
				alarm_Component.addValue(inData.componentName, inData.propertyName+"_0", ""+time_value, Double.parseDouble(clobArray[i+1]));
			}else{
				System.out.println("Componente nulo");
			}
//Date d = new Date(time_value);
//System.out.println(d);
Point point = Point.measurement(inData.componentName.replace("/","_")).time(time_value , TimeUnit.MILLISECONDS).tag("baciName", inData.propertyName+"_0").addField("value", Double.parseDouble(clobArray[i+1])).build();
	 		 batchPoints.point(point);

//java.util.Date time = new java.util.Date(Long.parseLong(clobArray[i]));


}
this.influxDB.write(batchPoints);
		}catch (NullPointerException ex) {
			log.warning("NULL POINTER EXCEPTION WHILE PREPARING MESSAGE TO MQ: " + ex.getMessage());
			ex.printStackTrace();
		}
	}

	public void close() {
		//if (this.myBlobConsumerThread != null) {
		//	this.myBlobConsumerThread.interrupt();
		//	this.myBlobConsumerThread = null;
		//}

		myBlobConsumer.cancel();

		if (mqEnabled && mqConnected) {
			log.info("About to disconnect from activeMQ ...");
			try {
				topicConnection.close();
			} catch (JMSException ex) {
				//throw new AcsJDBConnectionFailureEx("Error closing connection to JMS provider.", ex);
				log.warning("Failed to orderly close connection to JMS provider. " + ex);
			}
			mqConnected = false;
		}

		// after the above cancel() call, the loop should terminate itself. 
		// We wait up to 1000 ms, and log a warning if the loop takes longer or fails otherwise.
		blobConsumerExecutor.shutdown();
		boolean shutdownOK = false;
		try {
			shutdownOK = blobConsumerExecutor.awaitTermination(1000, TimeUnit.MILLISECONDS);
		} catch (InterruptedException ex) {
			// log below...
		}
		if (!shutdownOK) {
			log.warning("Failed to orderly shut down the blobConsumerExecutor within 1000 ms.");
		}
	}

	//TODO: This should eventually be moved to a connect() method in the future, as it is needed only once.
	public void openTransactionStore(String transactionName) throws AcsJDBConnectionFailureEx {
		//if (this.myBlobConsumerThread == null) {
		//	this.myBlobConsumerThread = this.containerServices.getThreadFactory().newThread(this.myBlobConsumer);
		//	this.myBlobConsumerThread.start();
		//}

		// If already connected, do nothing
		if (mqEnabled && !mqConnected) {
			log.info("About to connect to activeMQ ...");
			location = System.getenv("LOCATION");
			if (location == null) {
				location = "GENERIC";
			}
			try {
				log.info("Starting JMS connection.");
				ActiveMQConnectionFactory factory = new ActiveMQConnectionFactory(broker_url);
				topicConnection = factory.createTopicConnection();
				//TODO: This can eventually get stucked if the server (defined in archiveConfig) exists
				// but the port is unavailable. However, there is no way to set a connection timeout in
				// this class, so an alternative would be to use a thread and join with a timeout.
				// We should also consider to add a re-connection attempt in case of failure.
				topicConnection.start();
				topicSession = topicConnection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE);
				Topic topic = topicSession.createTopic(topic_name);
				topicPublisher = topicSession.createPublisher(topic);
			} catch (JMSException ex) {
				mqEnabled = false;
				//TODO: also send an alarm (see MonitorDAO.openTransactionStore)
				throw new AcsJDBConnectionFailureEx("No connection could be established with JMS provider.",  ex);
			}
			mqConnected = true;
		}
	}

	public void closeTransactionStore() throws AcsJDBConnectionFailureEx {
		// Do nothing.
	}


	/**
	 * This threadable class consumes the data queue.
	 */
	class BlobConsumer implements Runnable
	{
		protected volatile boolean shouldTerminate = false;

		public BlobConsumer() {
		}

		/**
		 * Sets a flag so that the run method will stop processing as soon as possible.
		 */
		public void cancel() {
			shouldTerminate = true;
		}

		public void run() {
			log.info("Starting MQ blob consumer thread.");
			Thread.currentThread().setName("MQBlobConsumerThread");
			long start=0;
			long end =0;
			ComponentData time = null;
			while(!shouldTerminate) {
				if (myMQDataQueue.size() > 0) {
					ComponentData tempBlobData = null;
					start = System.currentTimeMillis();
					try {
						// @TODO (hso): the possibly blocking call to take() circumvents thread termination based on the shouldTerminate flag.
						// See MonitorDAOImpl.BlobConsumer#run() for the use of "poll".
						tempBlobData = myMQDataQueue.take();
							if(tempBlobData.propertyName.equals("time")){
								time = tempBlobData;
							}
		
					} catch (InterruptedException ex) {
						ex.printStackTrace();
					}
					if(!tempBlobData.propertyName.equals("time")){
					try {
						mqStore(tempBlobData, time);
					} catch (Exception ex) {
						ex.printStackTrace();
					}
					end = System.currentTimeMillis();
					if ( log.isLoggable(Level.FINER) )
						log.finer(Thread.currentThread().getName()
							+ ":MQ consumer: data taken from the queue, queue size="
							+ myMQDataQueue.size() + " consume time=" + (end-start));
					}
				} else {
					//Thread.yield();
					try {
						Thread.sleep(500);
					} catch (InterruptedException ex) {
						log.log(Level.WARNING, "Unexpected InterruptedException in thread " + Thread.currentThread().getName()
								+ ". Will terminate this thread.", ex);
						break; // end the run method
					}
				}
			}
			int queueSize = myMQDataQueue.size();
			if (queueSize > 0) {
				log.warning("Terminating thread '" + Thread.currentThread().getName() +
					"' while the queue still contains " + queueSize + " BlobData elements.");
			}
		}
	}
}


