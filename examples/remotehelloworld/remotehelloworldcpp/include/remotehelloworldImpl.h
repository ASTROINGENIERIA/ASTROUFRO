#ifndef _REMOTEHELLOWORLDIMPL_H_
#define _REMOTEHELLOWORLDIMPL_H_


#include <acscomponentImpl.h>
#include <remotehelloworldS.h>
#include <helloworldS.h>
#include <acsComponentSmartPtr.h>
#include <baciROdouble.h>
#include <maciSimpleClient.h>
#include <acsThread.h>

class remotehelloworldImpl: public virtual acscomponent::ACSComponentImpl,
  public POA_Hello::remotehelloworld
{
        public:
                remotehelloworldImpl(const ACE_CString name, maci::ContainerServices * containerServices);
                virtual ~remotehelloworldImpl();

		virtual void initialize(void) throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl);
		virtual void execute(void) throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl);
		virtual void cleanUp(void);
		virtual void aboutToAbort(void);

		
		void sayHelloRemote(); 

        private:
                std::string component_name;
		//maci::SmartPtr< Hello::helloworld > hello_cpp;
		//maci::SmartPtr< Hello::helloworld > hello_py;
		//maci::SmartPtr< Hello::helloworld > hello_java;
		Hello::helloworld_var hello_cpp;
		Hello::helloworld_var hello_py;
		Hello::helloworld_var hello_java;
		//maci::SmartPtr< Sensors::sensortag > sensortag_sp;
};

#endif
