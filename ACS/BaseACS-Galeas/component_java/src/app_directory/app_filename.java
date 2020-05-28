package <app_directory>;

import java.util.logging.Logger;
import alma.ACS.ComponentStates;
import alma.JavaContainerError.wrappers.AcsJContainerServicesEx;
import alma.acs.component.ComponentLifecycle;
import alma.acs.container.ContainerServices;
import <idl_pragma_prefix>.<module_name>.<idl_filename>Operations;

public class <app_filename> implements ComponentLifecycle, <idl_filename>Operations{

	private ContainerServices m_containerServices;
	private Logger m_logger;

	public void initialize (ContainerServices containerServices) {
		m_containerServices = containerServices;
		m_logger = m_containerServices.getLogger();
		
	}

	public void execute() {
		
	}

	public void cleanUp() {
	}

	public void aboutToAbort() {
	}


	public ComponentStates componentState() {
		return m_containerServices.getComponentStateManager().getCurrentState();
	}
		
	public String name() {
		return m_containerServices.getName();
	}
}
