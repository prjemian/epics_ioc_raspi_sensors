# EPICS IOC on Raspberry Pi with sensors

This started as an EPICS synApps 5.8 IOC (xxx-5-8-3 template)
to watch various sensors using the GPIO capabilities of
the Raspberry Pi.

sensor | description | support
--- | --- | ---
DHT11 | humidity & temperature | superceded by DHT22
NTC100 | thermistor (temperature) | planned, use ADC over I2C
LDR | light-dependent resistor | planned, use ADC over I2C
HC-SR501 | PIR infrared proximity | planned
ADS1115 | 4 Channel 16 Bit I2C ADC | planned
MCP4725 | 12 Bit 2.7V-5.5V I2C DAC | planned
HC-SR04 | ultrasonic range | planned

Already, we have integrated many of these sensors on Arduino
connected by USB to the RPi and integrated in EPICS using 
the cmd_response protocol.  This work is to eliminate the need 
for the Arduino.  That can simplify deployment on the very
small form factor Raspberry Pi Zero W, which needs only a power
source and access to WiFi in order to become an EPICS IOC
on the LAN.
