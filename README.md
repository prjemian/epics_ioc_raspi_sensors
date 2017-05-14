# EPICS IOC on Raspberry Pi with GPIO sensors

This started as an 
[EPICS](http://www.aps.anl.gov/epics)
[3.15.5](http://www.aps.anl.gov/epics/base/R3-15/5.php)
plus
[synApps](https://www1.aps.anl.gov/BCDA/synApps)
[5.8](https://github.com/EPICS-synApps/support/releases/tag/synApps_5_8)
IOC ([xxx-5-8-3 template](https://github.com/epics-modules/xxx/releases/tag/R5-8-3))
to watch various sensors using the GPIO capabilities of
the Raspberry Pi.

sensor | description | support | comments
--- | --- | --- | ---
ADS1115 | 4 Channel 16 Bit I2C ADC | planned, use I2C bus | see [data table](documentation/dac-adc-calibration.md)
DHT11 | humidity & temperature | superceded by DHT22 | too unresponsive
DHT22 | humidity & temperature | complete ([v1.0](https://github.com/prjemian/ioc_raspi_sensors/releases/tag/v1.0) release) | reads every 1s
LDR | light-dependent resistor | planned, use ADC over I2C | voltage divider circuit
HC-SR04 | ultrasonic range | planned |
HC-SR501 | PIR infrared proximity | planned |
MCP4725 | 12 Bit 2.7V-5.5V I2C DAC | planned, use I2C bus | 
NTC10k | thermistor (temperature) | planned, use ADC over I2C | voltage divider circuit

Already, we have integrated many of these sensors on Arduino
connected by USB to the RPi and 
[integrated in EPICS](http://prjemian.github.io/cmd_response/epics/streams.html)
using the 
[cmd_response](http://prjemian.github.io/cmd_response/)
protocol.  This project eliminates the need 
for the Arduino.  Deployment is simplified on the very
small form factor Raspberry Pi Zero W, which needs only a power
source and access to WiFi in order to become an EPICS IOC
on the LAN.

Once built, the SD card can be imaged to create many such Raspberry Pi sensor 
IOCs, each having an identical array of sensors.
The only customization needed for each RPi is to set its unique hostname.
My practice is to base this name on the last four text characters in the output of 
`/proc/cpuino` (part of the unique RPi serial number).
The IOC is configured to use this as its PV prefix, ensuring (with some confidence)
that all its PVs will unique on the subnet.  Such as:

    pi@rpi170f:~ $ cat /proc/cpuinfo | tail -1
    Serial		: 000000004887170f
    pi@rpi170f:~ $ sudo hostname rpi170f

Then, all PVs will start with `rpi170f:`, such as:

EPICS PV | meaning
--- | ---
`rpi1705:pin0:humidity` |  most recent humidity reading
`rpi1705:pin0:temperature` | most recent temperature reading

It is possible but not likely to have two RPIs on your subnet that
match.  If you are so unlucky, add another digit or two to avoid this.
