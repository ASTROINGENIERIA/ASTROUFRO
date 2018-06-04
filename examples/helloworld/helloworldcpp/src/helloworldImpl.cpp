#include "helloworldImpl.h"


helloworldImpl::helloworldImpl(
		    const ACE_CString name,
		    maci::ContainerServices *containerServices) :
        ACSComponentImpl(name, containerServices)
{
  ACS_SHORT_LOG((LM_WARNING, "helloworldImpl::helloworldImpl()"));

  component_name = name.c_str();
}

helloworldImpl::~helloworldImpl()
{
}

void helloworldImpl::initialize()
        throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl)
{
  ACS_SHORT_LOG((LM_WARNING, "helloworldImpl::initialize()"));
  
  
  ACS_SHORT_LOG((LM_WARNING, "SensorTag Component Retrieved Successfully!"));
}

void helloworldImpl::execute()
        throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl)
{
}

void helloworldImpl::cleanUp()
{
  ACS_SHORT_LOG((LM_WARNING, "helloworldImpl::cleanUp()"));
  
  ACS_SHORT_LOG((LM_WARNING, "SensorTag Component Released Successfully!"));
}

void helloworldImpl::aboutToAbort()
{
} 


void helloworldImpl::sayHello()
{
  ACS_SHORT_LOG((LM_WARNING, "helloworldImpl::sayHello()"));

  ACSErr::Completion_var completion;
  std::cout << "OK" <<std::endl;
}


/* --------------- [ MACI DLL support functions ] -----------------*/
#include <maciACSComponentDefines.h>
MACI_DLL_SUPPORT_FUNCTIONS(helloworldImpl)
/* ----------------------------------------------------------------*/

