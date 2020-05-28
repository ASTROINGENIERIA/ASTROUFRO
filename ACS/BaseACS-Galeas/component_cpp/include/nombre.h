#ifndef _[NOMBRE]_H_
#define _[NOMBRE]_H_

#include <[Nombre_idl]S.h>
#include <[nombre].h>
#include <acsComponentSmartPtr.h>
#include <maciSimpleClient.h>

class [nombre]: public virtual acscomponent::ACSComponentImpl,
  public POA_[Modulo_en_idl]::[Nombre_idl]
{
        public:
                [nombre](const ACE_CString name, maci::ContainerServices * containerServices);
                virtual ~[nombre]();

		virtual void initialize(void) throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl);
		virtual void execute(void) throw (acsErrTypeLifeCycle::acsErrTypeLifeCycleExImpl);
		virtual void cleanUp(void);
		virtual void aboutToAbort(void);

		

        private:
                std::string component_name;
};

#endif
