import Telegram__POA
from Acspy.Servants.ContainerServices import ContainerServices
from Acspy.Servants.ComponentLifecycle import ComponentLifecycle
from Acspy.Servants.ACSComponent import ACSComponent
from Acspy.Clients.SimpleClient import PySimpleClient
from Acspy.Common.Log import getLogger

import logging
import argparse, time, threading, json, configparser, os, requests

class telegramalarm(Telegram__POA.telegramalarm,ACSComponent, ContainerServices, ComponentLifecycle):
	
	
    def __init__(self):
        ACSComponent.__init__(self)
        ContainerServices.__init__(self)
    def initialize(self):
        self.token = '776080328:AAFDFxj68BkahfazrqpkJNdsWw8QOUWtj5I'
        self.logger = self.getLogger()
        self.config = configparser.ConfigParser()
        self.config.read('config.ini')
        self.x = {}
    def cleanUp(self):
        self.releaseComponent("telegram_alarm")
		
    def myfunc(self):
        print self.x

    def addValue(self, node, baciName, timeBaci, value):
        if node not in self.x:
            self.x[node] = {}
        if baciName not in self.x[node]:
            self.x[node][baciName] = {}
            self.x[node][baciName]['alarm_status'] = 0
            if node in self.config.sections():
                self.limits(node, baciName)
        self.x[node][baciName]["time"] = timeBaci
        self.x[node][baciName]["value"] = value
        if 'subscribers' not in self.x[node]:
            self.updateSubscribers(node)
        if(self.x[node][baciName]['alarm_status'] == 0):
            if(baciName.replace("_0","_max") in self.x[node][baciName]):
                if(int(value) > self.x[node][baciName][baciName.replace("_0","_max")]):
                    self.x[node][baciName]['alarm_status'] = 1
                    self.alarmMax(node, baciName)
            if(baciName.replace("_0","_min") in self.x[node][baciName]):
                if(value < self.x[node][baciName][baciName.replace("_0","_min")]):
                    self.x[node][baciName]['alarm_status'] = 1
                    self.alarmMin(node, baciName)
        if(baciName.replace("_0","_max") in self.x[node][baciName] and baciName.replace("_0","_min") in self.x[node][baciName]):
            if(value >= self.x[node][baciName][baciName.replace("_0","_min")] and int(value) <= self.x[node][baciName][baciName.replace("_0","_max")]):
                self.x[node][baciName]['alarm_status'] = 0
        elif(baciName.replace("_0","_min") in self.x[node][baciName]):
            if(value >= self.x[node][baciName][baciName.replace("_0","_min")]):
                self.x[node][baciName]['alarm_status'] = 0
        elif(baciName.replace("_0","_max") in self.x[node][baciName]):
                if(int(value) <= self.x[node][baciName][baciName.replace("_0","_max")]):
                    self.x[node][baciName]['alarm_status'] = 0
                  

    def getValues(self):
        return self.x

    def clearAll(self):
    	self.x = {}

    def limits(self, node, name):
        for key in self.config[node]:
            if(key.find(name.replace("_0","_max"))!= -1):
                try:
                    self.x[node][name][key] = int(self.config[node][key])
                except:
                    time_property = name.replace("_0","_time_max")
                    if time_property in self.config[node]:
                        self.x[node][name][time_property] = self.config[node][time_property] 
                self.x[node][name]['alarm_status'] = 1
                
            elif(key.find(name.replace("_0","_min"))!= -1):
                try:
                    self.x[node][name][key] = int(self.config[node][key])
                except:
                    time_property = name.replace("_0","_time_min")
                    if time_property in self.config[node]:
                        self.x[node][name][time_property] = self.config[node][time_property]
                self.x[node][name]['alarm_status'] = 1

   
    def alarmMin(self, node,baci):
        msg = node+"/"+baci+" alarm min raised"
        allsubs = self.getSubscribers(node)
        if (len(allsubs) != 0):
            for user in allsubs:
                if(len(user)!=0):
                    self.send_message(user,msg)

    def alarmMax(self, node, baci):
        msg = node+"/"+baci+" alarm max raised"
        allsubs = self.getSubscribers(node)
        if (len(allsubs) != 0):
            for user in allsubs:
                if(len(user)!=0):
                    self.send_message(user,msg)

    def getValues(self, search):
        if search in self.x:
            return self.x[search]
        return null

    def getLocations(self):
        locations = []
        for location in self.x:
            locations.append(location)
        return locations
    
    def getOptions(self):
        options = ""
        for position in self.x:
            for baci in self.x[position]:
                if (baci != 'subscribers'):
                    options += position+"/"+baci.replace("_0","")+","
        if(options != ''):
            options[:-1]
            options = options.split(",")
        return options

    def getStatus(self):
        data = ""
        for position in self.x:
            for baci in self.x[position]:
            	if(baci != 'subscribers'):
                    if (self.x[position][baci]['alarm_status'] == 1):
                        data +=(position+"/"+baci.replace("_0","")+"   Alert\n")
                    else:
                        data +=(position+"/"+baci.replace("_0","")+"   OK\n")
        return data
    
    def addSubscriber(self, node, idsubs):
        allsubs = self.getSubscribers(node)
        config = configparser.ConfigParser()
        config.read('config.ini')
        if node not in self.config.sections():
            config.add_section(node)
        if (len(allsubs) !=0):
            subscribers = str(idsubs)+"".join(","+str(x) for x in allsubs)
        else:
            subscribers = str(idsubs)
        if str(idsubs) not in allsubs:
            config.set(node, 'subscribers', subscribers)
            with open('config.ini', 'w') as configfile:    # save
                config.write(configfile)
            self.updateSubscribers(node)

    def removeSubscriber (self, node, idsubs):
        allsubs = self.getSubscribers(node)
        config = configparser.ConfigParser()
        config.read('config.ini')
        if node not in self.config.sections():
            config.add_section(node)
        
        if str(idsubs) in allsubs:
            allsubs.remove(str(idsubs))
            if (len(allsubs) !=0):
                subscribers = "".join(","+str(x) for x in allsubs)
            else:
                subscribers = ""
            config.set(node, 'subscribers', subscribers)
            with open('config.ini', 'w') as configfile:    # save
                config.write(configfile)
            self.updateSubscribers(node)

    def reloadConfig(self):
        self.config = configparser.ConfigParser()
        self.config.read('config.ini')
        
    def getSubscribers(self, node):
        data = []
        if 'subscribers' not in self.x[node]:
            return data
        return self.x[node]['subscribers']
    
    def updateSubscribers(self, node):
        self.reloadConfig()
        data = []
        if node in self.config.sections():
            if 'subscribers' in self.config[node]:
                self.x[node]['subscribers'] = self.config[node]['subscribers'].strip().split(",")
    def send_values(self, chatid, data, baci):
        data = data.split(" ")
        location = self.getLocations()
        msg = ""
        for value in data:
            value = value.strip()
            if value in location:
                if baci.replace("/","")+"_0" in self.x[value]:
                    msg += value + '' + baci + '  '+ str(self.x[value][baci.replace("/","")+"_0"]['value'])+'\n'
            
        self.send_message(int(chatid), msg)

    def send_message(self, chatid, msg):
        requests.post(url='https://api.telegram.org/bot{0}/{1}'.format(self.token, 'sendMessage'), data={'chat_id': chatid, 'text': msg}).json()
    
    def send_status(self, chatid): 
    	msg = str(self.getStatus())
    	print msg
        self.send_message(int(chatid), msg)
        


    def send_subscribe(self, chatid, data):
        data = data.split(" ")
        location = self.getLocations()
        msg = ""
        for value in data:
            value = value.strip()
            if value in location:
                self.addSubscriber(value,chatid)
                msg += "Estas subscrito a "+value+"\n"
            else:
                msg += "No existe punto de monitoreo "+value+"\n"
        self.send_message(int(chatid), msg)


    def send_unsubscribe(self, chatid, data):
        data = data.split(" ")
        location = self.getLocations()
        msg = ""
        for value in data:
            value = value.strip()
            if value in location:
                self.removeSubscriber(value,chatid)
                msg += "No estas subscrito a "+value+"\n"
            else:
                msg += "No existe punto de monitoreo "+value+"\n"
        self.send_message(int(chatid), msg)

    
    def send_unsubscribeall(self, chatid):
        location = self.getLocations()
        msg = ""
        for value in location:
            self.removeSubscriber(value,chatid)
            msg += "No estas subscrito a "+value+"\n"
        self.send_message(int(chatid), msg)
        
    def send_subscribeall(self, chatid):
        location = self.getLocations()
        msg = ""
        for value in location:
            self.addSubscriber(value,chatid)
            msg += "Estas subscrito a "+value+"\n"
        self.send_message(int(chatid), msg)
        
    def send_echo_all(self, chatid): 
        comands = " ".join("\n"+str(x) for x in self.getOptions())
        msg = "Este bot funciona solo con los comandos de\n /temperature \n/light \n/presure \n/subscribe \n/unsubscribe \n/subscribeall \n/unsubscribeall\n/status \n\nLos sensores disponibles son:\n"+str(comands)
        self.send_message(int(chatid), msg)