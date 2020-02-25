#!/usr/bin/env python

"""
read DHT22, write to EPICS PVs

* Raspberry Pi 3 with 7"touch screen
* DHT22 humidity & temperature sensor
  * connections
  
    signal  pin #  description
    ======  =====  ===========
    +       17     3.3 VDC
    -       9      GND
    OUT     7      BCM4, GPIO4
"""

import Adafruit_DHT
import datetime
import epics
import time

# conect with EPICS IOC started as
# softIoc -m "P=gbr:,S=" dht22-softIoc.db
PREFIX = "gbr:"
SENSOR = ""

GPIO_PIN=4
SENSOR_MODEL=22
MINIMUM_WAIT_TIME=2.0
SLEEP_TIME=0.1


def DHT22_read():
    h, t = Adafruit_DHT.read_retry(
                  SENSOR_MODEL, GPIO_PIN)
    return h, t


def main():
    # connect with EPICS
    t_pv = epics.PV(PREFIX + SENSOR + "temperature")
    h_pv = epics.PV(PREFIX + SENSOR + "humidity")
    ymd_pv = epics.PV(PREFIX + SENSOR + "ymd")
    hms_pv = epics.PV(PREFIX + SENSOR + "hms")
    
    t_next = 0
    
    while True:
        if time.time() >= t_next:
            h, t = DHT22_read()
            # print(h, t)
            if h is not None:
                h_pv.put(h)
            if t is not None:
                t_pv.put(t)
            t_next = time.time() + MINIMUM_WAIT_TIME
        else:
            time.sleep(SLEEP_TIME)
        dt = datetime.datetime.now()
        ymd, hms = dt.isoformat(sep=" ").split(".")[0].split()
        ymd_pv.put(ymd)
        hms_pv.put(hms)


if __name__ == "__main__":
    main()
