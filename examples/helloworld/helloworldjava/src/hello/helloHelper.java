package hello;

import java.util.logging.Logger;

import example.Hello.helloworldOperations;
import example.Hello.helloworldPOATie;
import alma.acs.component.ComponentLifecycle;
import alma.acs.container.ComponentHelper;

/**
 * Component helper class. 
 * Generated for convenience, but can be modified by the component developer. 
 * Must therefore be treated like any other Java class (CVS, ...). 
 * <p>
 * To create an entry for your component in the Configuration Database, 
 * copy the line below into a new entry in the file $ACS_CDB/MACI/Components/Components.xml 
 * and modify the instance name of the component and the container: 
 * @author alma-component-helper-generator-tool
 */
public class helloHelper extends ComponentHelper
{
        /**
         * Constructor
         * @param containerLogger logger used only by the parent class.
         */
        public helloHelper(Logger containerLogger)
        {
                super(containerLogger);
        }

        /**
        * @see alma.acs.container.ComponentHelper#_createComponentImpl()
        */
        protected ComponentLifecycle _createComponentImpl()
        {
                return new helloImpl();
        }

        /**
        * @see alma.acs.container.ComponentHelper#_getPOATieClass()
        */
        protected Class _getPOATieClass()
        {
                return helloworldPOATie.class;
        }

        /**
        * @see alma.acs.container.ComponentHelper#getOperationsInterface()
        */
        protected Class _getOperationsInterface()
        {
                return helloworldOperations.class;
        }

}
