package alma.acs.tmcdb;
// Generated Dec 3, 2018 9:54:59 PM by Hibernate Tools 4.3.1.Final


import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.UniqueConstraint;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Parameter;

/**
 * Configuration generated by hbm2java
 */
@SuppressWarnings("serial")
@Entity
@Table(name="`CONFIGURATION`"
    , uniqueConstraints =  @UniqueConstraint(columnNames="`CONFIGURATIONNAME`")
)
public class Configuration extends alma.acs.tmcdb.translator.TmcdbObject implements java.io.Serializable {


     protected Integer configurationId;
     protected String configurationName;
     protected String fullName;
     protected Boolean active;
     protected Date creationTime;
     protected String description;
     private Set<HWConfiguration> HWConfigurations = new HashSet<HWConfiguration>(0);
     private Set<AlarmDefinition> alarmDefinitions = new HashSet<AlarmDefinition>(0);
     private Set<BL_VersionInfo> BL_VersionInfos = new HashSet<BL_VersionInfo>(0);
     private Set<Schemas> schemases = new HashSet<Schemas>(0);
     protected SnmpTrapSink snmpTrapSink;
     private Set<NetworkDevice> networkDevices = new HashSet<NetworkDevice>(0);
     private Set<FaultFamily> faultFamilies = new HashSet<FaultFamily>(0);
     private Set<NotificationServiceMapping> notificationServiceMappings = new HashSet<NotificationServiceMapping>(0);
     private Set<Container> containers = new HashSet<Container>(0);
     private Set<AlarmCategory> alarmCategories = new HashSet<AlarmCategory>(0);
     private Set<Component> components = new HashSet<Component>(0);
     private Set<EventChannel> eventChannels = new HashSet<EventChannel>(0);
     private Set<Manager> managers = new HashSet<Manager>(0);
     private Set<ReductionLink> reductionLinks = new HashSet<ReductionLink>(0);
     private Set<ReductionThreshold> reductionThresholds = new HashSet<ReductionThreshold>(0);
     private Set<AcsService> acsServices = new HashSet<AcsService>(0);

    public Configuration() {
    }
   
    @Id @GeneratedValue(generator="generator")
    @GenericGenerator(name="generator", strategy="native",
       parameters = {@Parameter(name="sequence", value="Config_seq")}
	)

    
    @Column(name="`CONFIGURATIONID`", unique=true, nullable=false)
    public Integer getConfigurationId() {
        return this.configurationId;
    }
    
    public void setConfigurationId(Integer configurationId) {    
        if( propertyChangeSupport != null )
            propertyChangeSupport.firePropertyChange("configurationId", this.configurationId, this.configurationId = configurationId);
        else
            this.configurationId = configurationId;
    }


    
    @Column(name="`CONFIGURATIONNAME`", unique=true, nullable=false, length=128)
    public String getConfigurationName() {
        return this.configurationName;
    }
    
    public void setConfigurationName(String configurationName) {    
        if( propertyChangeSupport != null )
            propertyChangeSupport.firePropertyChange("configurationName", this.configurationName, this.configurationName = configurationName);
        else
            this.configurationName = configurationName;
    }


    
    @Column(name="`FULLNAME`", nullable=false, length=256)
    public String getFullName() {
        return this.fullName;
    }
    
    public void setFullName(String fullName) {    
        if( propertyChangeSupport != null )
            propertyChangeSupport.firePropertyChange("fullName", this.fullName, this.fullName = fullName);
        else
            this.fullName = fullName;
    }


    
    @Column(name="`ACTIVE`", nullable=false)
    public Boolean getActive() {
        return this.active;
    }
    
    public void setActive(Boolean active) {    
        if( propertyChangeSupport != null )
            propertyChangeSupport.firePropertyChange("active", this.active, this.active = active);
        else
            this.active = active;
    }


    @Temporal(TemporalType.TIMESTAMP)
    @Column(name="`CREATIONTIME`", nullable=false, length=26)
    public Date getCreationTime() {
        return this.creationTime;
    }
    
    public void setCreationTime(Date creationTime) {    
        if( propertyChangeSupport != null )
            propertyChangeSupport.firePropertyChange("creationTime", this.creationTime, this.creationTime = creationTime);
        else
            this.creationTime = creationTime;
    }


    
    @Column(name="`DESCRIPTION`", nullable=false, length=16777216)
    public String getDescription() {
        return this.description;
    }
    
    public void setDescription(String description) {    
        if( propertyChangeSupport != null )
            propertyChangeSupport.firePropertyChange("description", this.description, this.description = description);
        else
            this.description = description;
    }


@OneToMany(fetch=FetchType.LAZY, mappedBy="configuration")
    public Set<HWConfiguration> getHWConfigurations() {
        return this.HWConfigurations;
    }
    
    public void setHWConfigurations(Set<HWConfiguration> HWConfigurations) {    
    	this.HWConfigurations = HWConfigurations;
    }

	public void addHWConfigurations(Set<HWConfiguration> elements) {
		if( this.HWConfigurations != null )
			for(Iterator<HWConfiguration> it = elements.iterator(); it.hasNext(); )
				addHWConfigurationToHWConfigurations((HWConfiguration)it.next());
	}

	public void addHWConfigurationToHWConfigurations(HWConfiguration element) {
		if( !this.HWConfigurations.contains(element) ) {
			this.HWConfigurations.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<AlarmDefinition> getAlarmDefinitions() {
        return this.alarmDefinitions;
    }
    
    public void setAlarmDefinitions(Set<AlarmDefinition> alarmDefinitions) {    
    	this.alarmDefinitions = alarmDefinitions;
    }

	public void addAlarmDefinitions(Set<AlarmDefinition> elements) {
		if( this.alarmDefinitions != null )
			for(Iterator<AlarmDefinition> it = elements.iterator(); it.hasNext(); )
				addAlarmDefinitionToAlarmDefinitions((AlarmDefinition)it.next());
	}

	public void addAlarmDefinitionToAlarmDefinitions(AlarmDefinition element) {
		if( !this.alarmDefinitions.contains(element) ) {
			this.alarmDefinitions.add(element);
		}
	}


@OneToMany(fetch=FetchType.LAZY, mappedBy="configuration")
    public Set<BL_VersionInfo> getBL_VersionInfos() {
        return this.BL_VersionInfos;
    }
    
    public void setBL_VersionInfos(Set<BL_VersionInfo> BL_VersionInfos) {    
    	this.BL_VersionInfos = BL_VersionInfos;
    }

	public void addBL_VersionInfos(Set<BL_VersionInfo> elements) {
		if( this.BL_VersionInfos != null )
			for(Iterator<BL_VersionInfo> it = elements.iterator(); it.hasNext(); )
				addBL_VersionInfoToBL_VersionInfos((BL_VersionInfo)it.next());
	}

	public void addBL_VersionInfoToBL_VersionInfos(BL_VersionInfo element) {
		if( !this.BL_VersionInfos.contains(element) ) {
			this.BL_VersionInfos.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<Schemas> getSchemases() {
        return this.schemases;
    }
    
    public void setSchemases(Set<Schemas> schemases) {    
    	this.schemases = schemases;
    }

	public void addSchemases(Set<Schemas> elements) {
		if( this.schemases != null )
			for(Iterator<Schemas> it = elements.iterator(); it.hasNext(); )
				addSchemasToSchemases((Schemas)it.next());
	}

	public void addSchemasToSchemases(Schemas element) {
		if( !this.schemases.contains(element) ) {
			this.schemases.add(element);
		}
	}


@OneToOne(fetch=FetchType.LAZY, mappedBy="configuration")
    public SnmpTrapSink getSnmpTrapSink() {
        return this.snmpTrapSink;
    }
    
    public void setSnmpTrapSink(SnmpTrapSink snmpTrapSink) {    
        if( propertyChangeSupport != null )
            propertyChangeSupport.firePropertyChange("snmpTrapSink", this.snmpTrapSink, this.snmpTrapSink = snmpTrapSink);
        else
            this.snmpTrapSink = snmpTrapSink;
    }


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<NetworkDevice> getNetworkDevices() {
        return this.networkDevices;
    }
    
    public void setNetworkDevices(Set<NetworkDevice> networkDevices) {    
    	this.networkDevices = networkDevices;
    }

	public void addNetworkDevices(Set<NetworkDevice> elements) {
		if( this.networkDevices != null )
			for(Iterator<NetworkDevice> it = elements.iterator(); it.hasNext(); )
				addNetworkDeviceToNetworkDevices((NetworkDevice)it.next());
	}

	public void addNetworkDeviceToNetworkDevices(NetworkDevice element) {
		if( !this.networkDevices.contains(element) ) {
			this.networkDevices.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<FaultFamily> getFaultFamilies() {
        return this.faultFamilies;
    }
    
    public void setFaultFamilies(Set<FaultFamily> faultFamilies) {    
    	this.faultFamilies = faultFamilies;
    }

	public void addFaultFamilies(Set<FaultFamily> elements) {
		if( this.faultFamilies != null )
			for(Iterator<FaultFamily> it = elements.iterator(); it.hasNext(); )
				addFaultFamilyToFaultFamilies((FaultFamily)it.next());
	}

	public void addFaultFamilyToFaultFamilies(FaultFamily element) {
		if( !this.faultFamilies.contains(element) ) {
			this.faultFamilies.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<NotificationServiceMapping> getNotificationServiceMappings() {
        return this.notificationServiceMappings;
    }
    
    public void setNotificationServiceMappings(Set<NotificationServiceMapping> notificationServiceMappings) {    
    	this.notificationServiceMappings = notificationServiceMappings;
    }

	public void addNotificationServiceMappings(Set<NotificationServiceMapping> elements) {
		if( this.notificationServiceMappings != null )
			for(Iterator<NotificationServiceMapping> it = elements.iterator(); it.hasNext(); )
				addNotificationServiceMappingToNotificationServiceMappings((NotificationServiceMapping)it.next());
	}

	public void addNotificationServiceMappingToNotificationServiceMappings(NotificationServiceMapping element) {
		if( !this.notificationServiceMappings.contains(element) ) {
			this.notificationServiceMappings.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<Container> getContainers() {
        return this.containers;
    }
    
    public void setContainers(Set<Container> containers) {    
    	this.containers = containers;
    }

	public void addContainers(Set<Container> elements) {
		if( this.containers != null )
			for(Iterator<Container> it = elements.iterator(); it.hasNext(); )
				addContainerToContainers((Container)it.next());
	}

	public void addContainerToContainers(Container element) {
		if( !this.containers.contains(element) ) {
			this.containers.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<AlarmCategory> getAlarmCategories() {
        return this.alarmCategories;
    }
    
    public void setAlarmCategories(Set<AlarmCategory> alarmCategories) {    
    	this.alarmCategories = alarmCategories;
    }

	public void addAlarmCategories(Set<AlarmCategory> elements) {
		if( this.alarmCategories != null )
			for(Iterator<AlarmCategory> it = elements.iterator(); it.hasNext(); )
				addAlarmCategoryToAlarmCategories((AlarmCategory)it.next());
	}

	public void addAlarmCategoryToAlarmCategories(AlarmCategory element) {
		if( !this.alarmCategories.contains(element) ) {
			this.alarmCategories.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<Component> getComponents() {
        return this.components;
    }
    
    public void setComponents(Set<Component> components) {    
    	this.components = components;
    }

	public void addComponents(Set<Component> elements) {
		if( this.components != null )
			for(Iterator<Component> it = elements.iterator(); it.hasNext(); )
				addComponentToComponents((Component)it.next());
	}

	public void addComponentToComponents(Component element) {
		if( !this.components.contains(element) ) {
			this.components.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<EventChannel> getEventChannels() {
        return this.eventChannels;
    }
    
    public void setEventChannels(Set<EventChannel> eventChannels) {    
    	this.eventChannels = eventChannels;
    }

	public void addEventChannels(Set<EventChannel> elements) {
		if( this.eventChannels != null )
			for(Iterator<EventChannel> it = elements.iterator(); it.hasNext(); )
				addEventChannelToEventChannels((EventChannel)it.next());
	}

	public void addEventChannelToEventChannels(EventChannel element) {
		if( !this.eventChannels.contains(element) ) {
			this.eventChannels.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<Manager> getManagers() {
        return this.managers;
    }
    
    public void setManagers(Set<Manager> managers) {    
    	this.managers = managers;
    }

	public void addManagers(Set<Manager> elements) {
		if( this.managers != null )
			for(Iterator<Manager> it = elements.iterator(); it.hasNext(); )
				addManagerToManagers((Manager)it.next());
	}

	public void addManagerToManagers(Manager element) {
		if( !this.managers.contains(element) ) {
			this.managers.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<ReductionLink> getReductionLinks() {
        return this.reductionLinks;
    }
    
    public void setReductionLinks(Set<ReductionLink> reductionLinks) {    
    	this.reductionLinks = reductionLinks;
    }

	public void addReductionLinks(Set<ReductionLink> elements) {
		if( this.reductionLinks != null )
			for(Iterator<ReductionLink> it = elements.iterator(); it.hasNext(); )
				addReductionLinkToReductionLinks((ReductionLink)it.next());
	}

	public void addReductionLinkToReductionLinks(ReductionLink element) {
		if( !this.reductionLinks.contains(element) ) {
			this.reductionLinks.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<ReductionThreshold> getReductionThresholds() {
        return this.reductionThresholds;
    }
    
    public void setReductionThresholds(Set<ReductionThreshold> reductionThresholds) {    
    	this.reductionThresholds = reductionThresholds;
    }

	public void addReductionThresholds(Set<ReductionThreshold> elements) {
		if( this.reductionThresholds != null )
			for(Iterator<ReductionThreshold> it = elements.iterator(); it.hasNext(); )
				addReductionThresholdToReductionThresholds((ReductionThreshold)it.next());
	}

	public void addReductionThresholdToReductionThresholds(ReductionThreshold element) {
		if( !this.reductionThresholds.contains(element) ) {
			this.reductionThresholds.add(element);
		}
	}


@OneToMany(cascade=CascadeType.PERSIST, fetch=FetchType.LAZY, mappedBy="configuration")
    @Cascade( {org.hibernate.annotations.CascadeType.SAVE_UPDATE, org.hibernate.annotations.CascadeType.LOCK} )
    public Set<AcsService> getAcsServices() {
        return this.acsServices;
    }
    
    public void setAcsServices(Set<AcsService> acsServices) {    
    	this.acsServices = acsServices;
    }

	public void addAcsServices(Set<AcsService> elements) {
		if( this.acsServices != null )
			for(Iterator<AcsService> it = elements.iterator(); it.hasNext(); )
				addAcsServiceToAcsServices((AcsService)it.next());
	}

	public void addAcsServiceToAcsServices(AcsService element) {
		if( !this.acsServices.contains(element) ) {
			this.acsServices.add(element);
		}
	}



   public boolean equalsContent(Object other) {
         if ( (this == other ) ) return true;
		 if ( (other == null ) ) return false;
		 if ( !(other instanceof Configuration) ) return false;
		 Configuration castOther = ( Configuration ) other;

		 return ( (this.getConfigurationName()==castOther.getConfigurationName()) || ( this.getConfigurationName()!=null && castOther.getConfigurationName()!=null && this.getConfigurationName().equals(castOther.getConfigurationName()) ) );
   }

   public int hashCodeContent() {
         int result = 17;

         
         result = 37 * result + ( getConfigurationName() == null ? 0 : this.getConfigurationName().hashCode() );
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         return result;
   }


}


