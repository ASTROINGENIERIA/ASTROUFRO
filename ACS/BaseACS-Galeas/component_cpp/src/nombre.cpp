#include "[nombre].h"


[nombre]::[nombre](
		    const ACE_CString name,
		    maci::ContainerServices *containerServices) :
        ACSComponentImpl(name, containerServices)
{

  component_name = name.c_str();
}

[nombre]::~[nombre]()
{
}

void [nombre]::initialize()
        throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl)
{

}

void [nombre]::execute()
        throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl)
{
}

void [nombre]::cleanUp()
{

}

void [nombre]::aboutToAbort()
{
} 




/* --------------- [ MACI DLL support functions ] -----------------*/
#include <maciACSComponentDefines.h>
MACI_DLL_SUPPORT_FUNCTIONS([nombre])
/* ----------------------------------------------------------------*/

