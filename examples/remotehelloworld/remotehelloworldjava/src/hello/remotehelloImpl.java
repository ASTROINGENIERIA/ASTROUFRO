package hello;

import java.util.logging.Logger;
import example.Hello.helloworld;
import example.Hello.helloworldHelper;
import alma.ACS.ComponentStates;
import alma.JavaContainerError.wrappers.AcsJContainerServicesEx;
import alma.acs.component.ComponentLifecycle;
import alma.acs.container.ContainerServices;

import example.Hello.remotehelloworldOperations;
public class remotehelloImpl implements ComponentLifecycle, remotehelloworldOperations{

private ContainerServices m_containerServices;
private Logger m_logger;
private helloworld hello_cppComponente;
private helloworld hello_pyComponente;
private helloworld hello_javaComponente;

public void initialize (ContainerServices containerServices) {
	m_containerServices = containerServices;
	m_logger = m_containerServices.getLogger();



		try {
		
		org.omg.CORBA.Object hello_cpp = m_containerServices.getComponent("Hello_cpp");
		org.omg.CORBA.Object hello_py = m_containerServices.getComponent("Hello_python");
		org.omg.CORBA.Object hello_java = m_containerServices.getComponent("Hello_java");
		
		hello_cppComponente = helloworldHelper.narrow(hello_cpp);
		hello_pyComponente = helloworldHelper.narrow(hello_py);
		hello_javaComponente = helloworldHelper.narrow(hello_java);
		m_logger.info("initialize() called...");

		if (hello_cppComponente == null) {
			throw new AcsJContainerServicesEx();
		}
		if (hello_pyComponente == null) {
			throw new AcsJContainerServicesEx();
		}
		if (hello_javaComponente == null) {
			throw new AcsJContainerServicesEx();
		}

	} catch (AcsJContainerServicesEx e) {
		e.printStackTrace();
	}
	
	
}

public void execute() {
	m_logger.info("execute() called...");
	
}

public void cleanUp() {
	m_logger.info("cleanUP() called... nothing to clean up.");
}

public void aboutToAbort() {
	m_logger.info("managed to abort");
}


public ComponentStates componentState() {
	return m_containerServices.getComponentStateManager().getCurrentState();
}
	
public String name() {
	return m_containerServices.getName();
}

public void sayHelloRemote() {
	hello_cppComponente.sayHello();
	hello_pyComponente.sayHello();
	hello_javaComponente.sayHello();
}

}
