# apt install libglib2.0-dev
# pip3 install bluepy
# sudo setcap 'cap_net_raw,cap_net_admin+eip' /home/pi/.local/lib/python3.5/site-packages/bluepy/bluepy-helper
# sudo setcap 'cap_net_raw,cap_net_admin+eip' ./ble-scan.py
# python3 ./ble-scan.py

# https://ianharvey.github.io/bluepy-doc/scanner.html
# https://github.com/IanHarvey/bluepy

# vim: expandtab shiftwidth=2 softtabstop=2

import time
from bluepy.btle import Scanner, DefaultDelegate

class ScanDelegate(DefaultDelegate):
  def __init__(self):
    DefaultDelegate.__init__(self)

  def handleDiscovery(self, dev, isNewDev, isNewData):
    if not dev.addr.startswith('58:2d:34'):
      return

    print("Data: %s  RSSI=%ddB" % (dev.addr, dev.rssi))
    for (adtype, desc, value) in dev.getScanData():
      print("  %s %s = %s" % (adtype, desc, value))

scanner = Scanner().withDelegate(ScanDelegate())
scanner.start(True)
while True:
  scanner.process()
  time.sleep(1)
