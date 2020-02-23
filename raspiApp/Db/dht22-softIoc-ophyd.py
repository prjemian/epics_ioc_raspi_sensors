
"""
ophyd object for the dht22-softIoc.db database

REFERENCES

* docs: https://blueskyproject.io/ophyd/
* repo: https://github.com/bluesky/ophyd
"""

__all__ = ["gbr",]

from ophyd import Component, Device, EpicsSignalRO

PREFIX = "gbr:"
SENSOR = ""

class SmootherDevice(Device):
    raw = Component(EpicsSignalRO, "", kind="hinted")
    s80 = Component(EpicsSignalRO, ":s80", kind="hinted")
    s95 = Component(EpicsSignalRO, ":s95", kind="hinted")
    s99 = Component(EpicsSignalRO, ":s99", kind="hinted")

class Dht22Device(Device):
    description = Component(EpicsSignalRO, "description")
    humidity = Component(SmootherDevice, "humidity")
    temperature = Component(SmootherDevice, "temperature")

gbr = Dht22Device(PREFIX+SENSOR, name="gbr")
