#!/usr/bin/env python2

# aptitude install python-pip libglib2.0-dev
# pip install bluepy

import binascii
import base64
# https://ianharvey.github.io/bluepy-doc/peripheral.html
from bluepy.btle import Peripheral, DefaultDelegate
import time
import sys

BATTERY_HANDLE = 0x0018
TEMP_HUM_WRITE_HANDLE = 0x0010
TEMP_HUM_WRITE_VALUE = bytearray([0x01, 0x10])
TEMP_HUM_READ_HANDLE = 0x000E

class TempHumDelegate(DefaultDelegate):
  def __init__(self):
    DefaultDelegate.__init__(self)

  def handleNotification(self, cHandle, data):
    if (cHandle == TEMP_HUM_READ_HANDLE):
      data = data.rstrip(' \t\r\n\0')
      temperature = data.split(" ")[0][2:]
      humidity = data.split(" ")[1][2:]
      print 't=%s h=%s' % (temperature, humidity)

def get_battery_level():
  val = p.readCharacteristic(BATTERY_HANDLE)
  return int(binascii.b2a_hex(val), 16)

mac = sys.argv[1]
print 'MAC: %s' % mac
p = Peripheral(mac)
p.withDelegate(TempHumDelegate())

print 'Battery: %s' % get_battery_level()
p.writeCharacteristic(TEMP_HUM_WRITE_HANDLE, TEMP_HUM_WRITE_VALUE)
while True:
  p.waitForNotifications(5.0)

p.disconnect()
