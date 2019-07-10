#! /usr/bin/env python
# -*- coding: utf-8 -*-
#*******************************************************************************
# ALMA - Atacama Large Millimiter Array
# Copyright (c) Associated Universities Inc., 2017 
# 
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
#
#
# who       when      what
# --------  --------  ----------------------------------------------
# ruben.soto  2017-06-12  created
#

#************************************************************************
#   NAME
# 
#   SYNOPSIS
# 
#   DESCRIPTION
#
#   FILES
#
#   ENVIRONMENT
#
#   RETURN VALUES
#
#   CAUTIONS
#
#   EXAMPLES
#
#   SEE ALSO
#
#   BUGS     
#
#------------------------------------------------------------------------
#

# Import the acspy.PySimpleClient class
import telebot
import time, requests
from Acspy.Clients.SimpleClient import PySimpleClient


# Make an instance of the PySimpleClient
simpleClient = PySimpleClient()

# Print information about the available COBs

# Do something on a device.
bot = telebot.TeleBot("776080328:AAFDFxj68BkahfazrqpkJNdsWw8QOUWtj5I")
ta = simpleClient.getComponent("TelegramAlarm")
#ta.clearAll();

@bot.message_handler(commands=['start', 'help'])
def send_welcome(message):
    chatid = message.chat.id
    nombreUsuario= message.chat.first_name
    saludo = "Hola {nombre}, bienvenido al boot de AstroUFRO; ¿Que deseas saber?."
    bot.send_message(chatid, saludo.format(nombre=nombreUsuario))
    chatid = str(message.chat.id)
    ta.send_echo_all(chatid)  #metodo; cuando el bot reciba los comandos indicados, realizara la siguiente accion

@bot.message_handler(commands=['temperature', 'pressure', 'light', 'humidity', 'dioxide', 'oxygen'])
def send_values(message):
    chatid = str(message.chat.id)
    data = message.text.replace("/temperature","").replace("/pressure","").replace("/light","").replace("/humidity","").replace("/dioxide","").replace("/oxygen","").strip()
    ta.send_values(chatid, str(data), str(message.text.split(" ")[0]))
    #bot.send_message(chatid, msg)

@bot.message_handler(commands=['status'])
def send_status(message):
    chatid = str(message.chat.id)        
    ta.send_status(chatid)
    #bot.send_message(chatid, msg)

@bot.message_handler(commands=['subscribe'])
def send_subscribe(message):
    chatid = str(message.chat.id)
    data = message.text.replace("/subscribe","").strip()
    ta.send_subscribe(chatid, str(data))
    #bot.send_message(chatid, msg)

@bot.message_handler(commands=['unsubscribe'])
def send_unsubscribe(message):
    chatid = str(message.chat.id)
    data = message.text.replace("/unsubscribe","").strip()
    ta.send_unsubscribe(chatid, str(data))
    #bot.send_message(chatid, msg)
      

@bot.message_handler(commands=['unsubscribeall'])
def send_unsubscribeall(message):
    print "hola"
    chatid = str(message.chat.id)
    ta.send_unsubscribeall(chatid)
    #bot.send_message(chatid, msg)
@bot.message_handler(commands=['subscribeall'])
def send_subscribeall(message):
    chatid = str(message.chat.id)
    ta.send_subscribeall(chatid)
    #bot.send_message(chatid, msg)


@bot.message_handler(func=lambda message: True)
def echo_all(message):
    chatid = str(message.chat.id)
    ta.send_echo_all(chatid)
    


bot.infinity_polling(True)

simpleClient.releaseComponent("TelegramAlarm")
simpleClient.disconnect()
print "The end __oOo__"
#
# ___oOo___
