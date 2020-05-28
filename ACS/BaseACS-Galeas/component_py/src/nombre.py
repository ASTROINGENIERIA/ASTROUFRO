import [Nombre_modulo]__POA
from Acspy.Servants.ContainerServices import ContainerServices
from Acspy.Servants.ComponentLifecycle import ComponentLifecycle
from Acspy.Servants.ACSComponent import ACSComponent
from Acspy.Clients.SimpleClient import PySimpleClient
from Acspy.Common.Log import getLogger


class [nombre]([Nombre_modulo]__POA.[Nombre_idl],ACSComponent, ContainerServices, ComponentLifecycle):
	
	
	def __init__(self):
		ACSComponent.__init__(self)
		ContainerServices.__init__(self)
		

		pass

	def initialize(self):
		#Acciones al iniciar

	def cleanUp(self):
		#Aciones al liberar componente

