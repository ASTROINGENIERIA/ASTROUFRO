import Hello__POA
from Acspy.Servants.ContainerServices import ContainerServices
from Acspy.Servants.ComponentLifecycle import ComponentLifecycle
from Acspy.Servants.ACSComponent import ACSComponent
from Acspy.Clients.SimpleClient import PySimpleClient
from Acspy.Common.Log import getLogger

import logging


class remotehelloworld(Hello__POA.remotehelloworld,ACSComponent, ContainerServices, ComponentLifecycle):
	
	
	def __init__(self):
		ACSComponent.__init__(self)
		ContainerServices.__init__(self)
		


	def initialize(self):
		'''
		Override this method inherited from ComponentLifecycle
		'''
		self.logger = self.getLogger()
		try:
			self.helloworldcpp = self.getComponent( "Hello_cpp")
		except:
			self.getLogger().logInfo("Unable to get Hello_cpp component")
		try:
			self.helloworldpy = self.getComponent( "Hello_python")
		except:
			self.getLogger().logInfo("Unable to get Hello_python component")
		try:
			self.helloworldjava = self.getComponent( "Hello_java")
		except:
			self.getLogger().logInfo("Unable to get Hello_java component")

	def cleanUp(self):
		'''
		Override this method inherited from ComponentLifecycle
		'''
		#self.getLogger().logInfo("CONSOLE 2 CLEANUP ACCESS")
		self.releaseComponent("Hello_python")
	def sayHelloRemote(self):
		try:
			self.helloworldcpp.sayHello()
		except:
			self.getLogger().logInfo("Problem to call sayHello() cpp")
		try:
			self.helloworldpy.sayHello()
		except:
			self.getLogger().logInfo("Problem to call sayHello() python")
		try:
			self.helloworldjava.sayHello()
		except:
			self.getLogger().logInfo("Problem to call sayHello() java")
		
