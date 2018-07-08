package hello;

import java.util.logging.Logger;

import example.Hello.remotehelloworldOperations;
import example.Hello.remotehelloworldPOATie;
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
public class remotehelloHelper extends ComponentHelper
{
        /**
         * Constructor
         * @param containerLogger logger used only by the parent class.
         */
        public remotehelloHelper(Logger containerLogger)
        {
                super(containerLogger);
        }

        /**
        * @see alma.acs.container.ComponentHelper#_createComponentImpl()
        */
        protected ComponentLifecycle _createComponentImpl()
        {
                return new remotehelloImpl();
        }

        /**
        * @see alma.acs.container.ComponentHelper#_getPOATieClass()
        */
        protected Class _getPOATieClass()
        {
                return remotehelloworldPOATie.class;
        }

        /**
        * @see alma.acs.container.ComponentHelper#getOperationsInterface()
        */
        protected Class _getOperationsInterface()
        {
                return remotehelloworldOperations.class;
        }

}
