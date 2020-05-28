package HolaPerroApp;

import java.util.logging.Logger;
import alma.ACS.ComponentStates;
import alma.JavaContainerError.wrappers.AcsJContainerServicesEx;
import alma.acs.component.ComponentLifecycle;
import alma.acs.container.ContainerServices;
import ufro.Animales.IHolaPerroOperations;

public class Perro implements ComponentLifecycle, IHolaPerroOperations{

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

	public String ladrar() {
		return "Guau, Guau!"
	}
}
