#ifndef _SENSORTAG_IMPL_H_
#define _SENSORTAG_IMPL_H_

#include <sensortagS.h>

#include <baciCharacteristicComponentImpl.h>
#include <baciSmartPropertyPointer.h>
#include <baciROdouble.h>
#include <baciROlongLong.h>
#include <baciDevIO.h>
#include <acsThread.h>
#include <mqtt_devio.h>

class sensortag_thread;

class sensortag_impl:   public virtual POA_Sensors::sensortag,
        public baci::CharacteristicComponentImpl
{
        public:
                sensortag_impl(const ACE_CString name, maci::ContainerServices * containerServices);
                virtual ~sensortag_impl();

                ACS::ROdouble_ptr temperature();
                ACS::ROdouble_ptr light();
                ACS::ROdouble_ptr pressure();
                ACS::ROdouble_ptr humidity();
                ACS::ROdouble_ptr oxygen();
                ACS::ROdouble_ptr dioxide();
		ACS::ROlongLong_ptr time();


			void publishTemperature();
			void publishLight();
			void publishPressure();
                        void publishHumidity();
                        void publishOxygen();
                        void publishDioxide();
			void publishTime();
		        void on();
		        void off();		

                virtual void initialize(void) throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl);
                virtual void execute(void) throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl);
                virtual void cleanUp(void);
                virtual void aboutToAbort(void);

        private:
                baci::SmartPropertyPointer<baci::ROdouble> temperature_m;
                baci::SmartPropertyPointer<baci::ROdouble> light_m;
                baci::SmartPropertyPointer<baci::ROdouble> pressure_m;
                baci::SmartPropertyPointer<baci::ROdouble> humidity_m;
                baci::SmartPropertyPointer<baci::ROdouble> dioxide_m;
                baci::SmartPropertyPointer<baci::ROdouble> oxygen_m;
		baci::SmartPropertyPointer<baci::ROlongLong> time_m;

                mqtt::mqtt_read * temperature_devio_m;
                mqtt::mqtt_read * light_devio_m;
                mqtt::mqtt_read * pressure_devio_m;
                mqtt::mqtt_read * humidity_devio_m;
                mqtt::mqtt_read * dioxide_devio_m;
                mqtt::mqtt_read * oxygen_devio_m;
		mqtt::mqtt_readlong * time_devio_m;
		
		mqtt::mqtt_write * temperature_devio_w;
		mqtt::mqtt_write * light_devio_w;
		mqtt::mqtt_write * pressure_devio_w;
                mqtt::mqtt_write * humidity_devio_w;
                mqtt::mqtt_write * dioxide_devio_w;
                mqtt::mqtt_write * oxygen_devio_w;
		mqtt::mqtt_write * time_devio_w;


                std::string component_name;
		std::string component_broker;
		std::string client_name;
                sensortag_thread * refresh_thread;
};


#endif
