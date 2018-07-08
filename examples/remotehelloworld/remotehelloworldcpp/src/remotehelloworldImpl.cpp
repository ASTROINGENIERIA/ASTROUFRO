#include "remotehelloworldImpl.h"


remotehelloworldImpl::remotehelloworldImpl(
		    const ACE_CString name,
		    maci::ContainerServices *containerServices) :
        ACSComponentImpl(name, containerServices),
		hello_cpp(Hello::helloworld::_nil()), hello_py(Hello::helloworld::_nil()), hello_java(Hello::helloworld::_nil())
{
  ACS_SHORT_LOG((LM_WARNING, "remotehelloworld::remotehelloworld()"));

  component_name = name.c_str();
	try
	{
		hello_cpp = getContainerServices()->getComponent<Hello::helloworld>("Hello_cpp");
	}
	catch(int e)
	{
		ACS_SHORT_LOG((LM_INFO, "Unable to get Hello_cpp component"));
	}
	try
	{
		hello_py = getContainerServices()->getComponent<Hello::helloworld>("Hello_python");
	}
	catch(int e)
	{
		ACS_SHORT_LOG((LM_INFO, "Unable to get Hello_python component"));
	}
	try
	{
		hello_java = getContainerServices()->getComponent<Hello::helloworld>("Hello_java");
	}
	catch(int e)
	{
		ACS_SHORT_LOG((LM_INFO, "Unable to get RemoteHello_java component"));
	}
}

remotehelloworldImpl::~remotehelloworldImpl()
{

}

void remotehelloworldImpl::initialize()
        throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl)
{
  ACS_SHORT_LOG((LM_WARNING, "remotehelloworld::initialize()"));
  
  
  ACS_SHORT_LOG((LM_WARNING, "remotehelloworld Component Retrieved Successfully!"));
}

void remotehelloworldImpl::execute()
        throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl)
{
}

void remotehelloworldImpl::cleanUp()
{
  ACS_SHORT_LOG((LM_WARNING, "remotehelloworld::cleanUp()"));
  
  ACS_SHORT_LOG((LM_WARNING, "helloworld Component Released Successfully!"));
}

void remotehelloworldImpl::aboutToAbort()
{
} 


void remotehelloworldImpl::sayHelloRemote()
{
 	try
	{
		hello_cpp->sayHello();	
		ACS_SHORT_LOG((LM_INFO, "Called sayHello() cpp"));
	}
		
	catch(int e)
	{
		ACS_SHORT_LOG((LM_INFO, "Problem to call sayHello() cpp"));
	}
	try
	{
		hello_py->sayHello();	
		ACS_SHORT_LOG((LM_INFO, "Called sayHello() python"));
	}
		
	catch(int e)
	{
		ACS_SHORT_LOG((LM_INFO, "Problem to call sayHello() python"));
	}
	try
	{
		hello_java->sayHello();	
		ACS_SHORT_LOG((LM_INFO, "Called sayHello() java"));
	}
		
	catch(int e)
	{
		ACS_SHORT_LOG((LM_INFO, "Problem to call sayHello() cpp"));
	}
}


/* --------------- [ MACI DLL support functions ] -----------------*/
#include <maciACSComponentDefines.h>
MACI_DLL_SUPPORT_FUNCTIONS(remotehelloworldImpl)
/* ----------------------------------------------------------------*/

