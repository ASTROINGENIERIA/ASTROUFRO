#include "sensortag_impl.h"
#include "mqtt_devio.h"

sensortag_impl::sensortag_impl(
                const ACE_CString name, 
                maci::ContainerServices *containerServices) :
        CharacteristicComponentImpl(name, containerServices),
        temperature_m(this), light_m(this), pressure_m(this), humidity_m(this), dioxide_m(this), oxygen_m(this), time_m(this)

{
    /* get broker url from CDB */    
    try 
	{
	CORBA::Any* characteristic = get_characteristic_by_name("broker");
	if (!(*characteristic>>=component_broker))
	    {
	    ACS_SHORT_LOG((LM_ERROR,"Error getting broker by the CORBA::Any object"));
	    }
	}
    catch (...)
	{
	ACS_SHORT_LOG((LM_ERROR,"Error reading the characteristic broker by its name"));
	}
    /* get client_id from CDB */
    try 
	{
	CORBA::Any* characteristic = get_characteristic_by_name("client_id");
	if (!(*characteristic>>=client_name))
	    {
	    ACS_SHORT_LOG((LM_ERROR,"Error getting client_name by the CORBA::Any object"));
	    }
	}
    catch (...)
	{
	ACS_SHORT_LOG((LM_ERROR,"Error reading the characteristic broker by its name"));
	}
	component_name = name.c_str();
}

sensortag_impl::~sensortag_impl()
{
    delete temperature_devio_m;
    delete light_devio_m;
    delete pressure_devio_m;
    delete humidity_devio_m;
    delete dioxide_devio_m;
    delete oxygen_devio_m;
    delete time_devio_m;

    delete temperature_devio_w;
    delete light_devio_w;
    delete pressure_devio_w;
    delete humidity_devio_w;
    delete dioxide_devio_w;
    delete oxygen_devio_w;
    delete time_devio_w;
}

void sensortag_impl::initialize()
        throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl)
{
	/* 
	* Subscription to topics
	* client name is configurable in CDB 
	* two or more subscriptions to the same topic can not be made with the same client name
	*/
        time_devio_m = new mqtt::mqtt_readlong(component_broker,
                            (component_name  + "/time").c_str(), client_name + "/time/r");
        temperature_devio_m = new mqtt::mqtt_read(component_broker, 
                            (component_name + "/temperature").c_str(), client_name + "/temperature/r");
        light_devio_m = new mqtt::mqtt_read(component_broker, 
                            (component_name +  "/light").c_str(), client_name +  "/light/r");
        pressure_devio_m = new mqtt::mqtt_read(component_broker, 
                            (component_name  + "/pressure").c_str(), client_name + "/pressure/r");
	
        humidity_devio_m = new mqtt::mqtt_read(component_broker, 
                            (component_name  + "/humidity").c_str(), client_name + "/humidity/r");
        dioxide_devio_m = new mqtt::mqtt_read(component_broker, 
                            (component_name  + "/dioxide").c_str(), client_name + "/dioxide/r");
        oxygen_devio_m = new mqtt::mqtt_read(component_broker, 
                            (component_name  + "/oxygen").c_str(), client_name + "/oxygen/r");
/*	temperature_devio_w = new mqtt::mqtt_write(component_broker, 
                            ("w/" + component_name + "/temperature").c_str(), client_name + "/temperature/w");
	light_devio_w = new mqtt::mqtt_write(component_broker, 
		                    ("w/" + component_name + "/light").c_str(), client_name +  "/light/w");
	humidity_devio_w = new mqtt::mqtt_write(component_broker, 
		                    ("w/" + component_name + "/pressure").c_str(), client_name + "/pressure/w");
*/	
         time_m = new baci::ROlongLong (
                        (component_name + ":time").c_str(),
                        getComponent(),
                        time_devio_m);
        temperature_m =  new baci::ROdouble(
			(component_name + ":temperature").c_str(),
                        getComponent(), 
                        temperature_devio_m);
        light_m = new baci::ROdouble(
			(component_name + ":light").c_str(),
                        getComponent(), 
                        light_devio_m);
        pressure_m = new baci::ROdouble (
			(component_name + ":pressure").c_str(),
                        getComponent(), 
                        pressure_devio_m);
        humidity_m = new baci::ROdouble (
            (component_name + ":humidity").c_str(),
                        getComponent(), 
                        humidity_devio_m);
        dioxide_m = new baci::ROdouble (
            (component_name + ":dioxide").c_str(),
                        getComponent(), 
                        dioxide_devio_m);
        oxygen_m = new baci::ROdouble (
            (component_name + ":oxygen").c_str(),
                        getComponent(), 
                        oxygen_devio_m);


//        temperature_m =  new baci::ROdouble(
//			(component_name + ":temperature").c_str(),
//                        getComponent(), new sensortag_devio(sensortag_devio::temperatue_t, refresh_thread));
//        light_m = new baci::ROdouble(
//			(component_name + ":light").c_str(),
//                        getComponent(), new sensortag_devio(sensortag_devio::light_t, refresh_thread));
//        pressure_m = new baci::ROdouble (
//			(component_name + ":pressure").c_str(),
//                        getComponent(), new sensortag_devio(sensortag_devio::pressure_t, refresh_thread));
	
}

void sensortag_impl::execute()
        throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl)
{
}

void sensortag_impl::cleanUp()
{
//        AUTO_TRACE(__PRETTY_FUNCTION__);
//        if (refresh_thread) {
//                try {
//                    this->off();
//                } catch(...) {
//                        ACS_SHORT_LOG((LM_WARNING, "Something went wrong with thr thread deactivation :("));
//                }
//        }
//        getContainerServices()->getThreadManager()->stopAll();
}

void sensortag_impl::aboutToAbort(){
}

ACS::ROdouble_ptr sensortag_impl::temperature()
{
        if (temperature_m == 0)
                return ACS::ROdouble::_nil();
        ACS::ROdouble_var prop = ACS::ROdouble::_narrow(temperature_m->getCORBAReference());
	return prop._retn();
}

ACS::ROdouble_ptr sensortag_impl::light()
{
        if (light_m == 0)
                return ACS::ROdouble::_nil();
        ACS::ROdouble_var prop = ACS::ROdouble::_narrow(light_m->getCORBAReference());
        return prop._retn();
}

ACS::ROdouble_ptr sensortag_impl::pressure()
{
        if (pressure_m == 0)
               return ACS::ROdouble::_nil();
        ACS::ROdouble_var prop = ACS::ROdouble::_narrow(pressure_m->getCORBAReference());
	return prop._retn();
}
ACS::ROdouble_ptr sensortag_impl::humidity()
{
        if (humidity_m == 0)
               return ACS::ROdouble::_nil();
        ACS::ROdouble_var prop = ACS::ROdouble::_narrow(humidity_m->getCORBAReference());
    return prop._retn();
}
ACS::ROdouble_ptr sensortag_impl::oxygen()
{
        if (oxygen_m == 0)
               return ACS::ROdouble::_nil();
        ACS::ROdouble_var prop = ACS::ROdouble::_narrow(oxygen_m->getCORBAReference());
    return prop._retn();
}
ACS::ROdouble_ptr sensortag_impl::dioxide()
{
        if (dioxide_m == 0)
               return ACS::ROdouble::_nil();
        ACS::ROdouble_var prop = ACS::ROdouble::_narrow(dioxide_m->getCORBAReference());
    return prop._retn();
}

ACS::ROlongLong_ptr sensortag_impl::time()
{
        if (time_m == 0)
                return ACS::ROlongLong::_nil();
        ACS::ROlongLong_var prop = ACS::ROlongLong::_narrow(time_m->getCORBAReference());
        return prop._retn();
}

void sensortag_impl::publishTemperature()
{
	temperature_devio_w->publish("Temperature message");
}
void sensortag_impl::publishLight()
{
	light_devio_w->publish("Light message");
}
void sensortag_impl::publishPressure()
{
	pressure_devio_w->publish("Pressure message");
}
void sensortag_impl::publishOxygen()
{
    oxygen_devio_w->publish("Oxygen message");
}
void sensortag_impl::publishHumidity()
{
    humidity_devio_w->publish("Humidity message");
}
void sensortag_impl::publishDioxide()
{
    dioxide_devio_w->publish("Dioxide message");
}
void sensortag_impl::publishTime()
{
        time_devio_w->publish("Time message");
}


void sensortag_impl::on()
{
//        AUTO_TRACE(__PRETTY_FUNCTION__);
//        if (refresh_thread == NULL) {
//                refresh_thread = getContainerServices()->getThreadManager()->
//                        create<sensortag_thread>(ACE_CString("sensortag_refresh_thread"));
//                        refresh_thread->resume();
//        } else {
//                refresh_thread->resume();
//        }
}

void sensortag_impl::off()
{
//        AUTO_TRACE(__PRETTY_FUNCTION__);
//        if(refresh_thread != NULL) {
//                refresh_thread->suspend();
//        }
}

/* --------------- [ MACI DLL support functions ] -----------------*/
#include <maciACSComponentDefines.h>
MACI_DLL_SUPPORT_FUNCTIONS(sensortag_impl)
/* ----------------------------------------------------------------*/

