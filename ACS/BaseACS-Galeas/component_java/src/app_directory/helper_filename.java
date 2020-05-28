package <app_directory>;

import java.util.logging.Logger;

import <idl_pragma_prefix>.<module_name>.<idl_filename>Operations;
import <idl_pragma_prefix>.<module_name>.<idl_filename>POATie;
import alma.acs.component.ComponentLifecycle;
import alma.acs.container.ComponentHelper;

public class <helper_filename> extends ComponentHelper {

        public <helper_filename>(Logger containerLogger) {
                super(containerLogger);
        }

        protected ComponentLifecycle _createComponentImpl() {
                return new <app_filename>();
        }

        protected Class _getPOATieClass() {
                return <idl_filename>POATie.class;
        }

        protected Class _getOperationsInterface() {
                return <idl_filename>Operations.class;
        }
}
