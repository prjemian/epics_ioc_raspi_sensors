# EPICS IOC on Raspberry Pi with GPIO sensors

This started as an 
[EPICS](http://www.aps.anl.gov/epics)
[3.15.5](http://www.aps.anl.gov/epics/base/R3-15/5.php)
[synApps](https://www1.aps.anl.gov/BCDA/synApps)
[5.8](https://github.com/EPICS-synApps/support/releases/tag/synApps_5_8)
IOC ([xxx-5-8-3 template](https://github.com/epics-modules/xxx/releases/tag/R5-8-3))
to watch various sensors using the GPIO capabilities of
the Raspberry Pi.

sensor | description | support | comments
--- | --- | --- | ---
ADS1115 | 4 Channel 16 Bit I2C ADC | planned, use I2C bus | see [data table](documentation/dac-adc-calibration.md)
DHT11 | humidity & temperature | superceded by DHT22 | too unresponsive
DHT22 | humidity & temperature | with [v1.0](https://github.com/prjemian/ioc_raspi_sensors/releases/tag/v1.0) release | reads every 1s
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
protocol.  This project is to eliminate the need 
for the Arduino.  That can simplify deployment on the very
small form factor Raspberry Pi Zero W, which needs only a power
source and access to WiFi in order to become an EPICS IOC
on the LAN.
