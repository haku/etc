#!/usr/bin/env python3

# aptitude install python3-pip libglib2.0-dev
# pip3 install btlewrap

import sys
from btlewrap.base import BluetoothInterface
from btlewrap.gatttool import GatttoolBackend

HANDLE_READ_BATTERY_LEVEL = 0x0018
HANDLE_READ_WRITE_SENSOR_DATA = 0x0010

class TempHumDelegate():
  def handleNotification(self, handle, data):
    print('Notification: handle=%s data=%s' % (handle, data))

mac = sys.argv[1]
print('MAC: %s' % mac)

bt_interface = BluetoothInterface(GatttoolBackend, adapter='hci0')
with bt_interface.connect(mac) as connection:
    res_battery = connection.read_handle(HANDLE_READ_BATTERY_LEVEL)
    battery = int(ord(res_battery))
    print('Battery: %s' % battery)

    connection.wait_for_notification(
            HANDLE_READ_WRITE_SENSOR_DATA,
            TempHumDelegate(),
            10)
