from Acspy.Clients.SimpleClient import PySimpleClient
client=PySimpleClient()
ws=client.getComponent("OPCUA_CPP")
ws.get_nCounter()
ws.get_iVar1()
ws.get_iVar2()
ws.set_iVar1(500)
ws.set_iVar2(1000)
