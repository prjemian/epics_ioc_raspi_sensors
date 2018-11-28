# Notes on starting with DHT22 and Raspberry Pi Zero W

date: 2018-11-26

# Starting materials

* Raspberry Pi Zero W v1.1 motherboard
* DHT22 sensor with socketed connectors
* header pins, double row
* Power supply, 5V, 2A, micro USB connector
* HDMI adapter cable, mini-HDMI to HDMI
* video cable: HDMI
* video monitor, HDMI
* USB adapter cable: OTA, micro USB to USB
* Logitech wireless USB keyboard and touch pad combo
* 16GB micro SD card
* existing computer to download the image and write to the micro SD card
   * 2018-11-13-raspbian-stretch-full.zip image 
     (latest from https://www.raspberrypi.org/downloads/raspbian/)
   * Etcher software (https://etcher.io)

1. On an existing computer, download the latest Raspbian image from 
   raspberrypi.org.
1. Using Etcher (from etcher.io), write the ZIP file image to
   the micro SD card
1. Move the micro SD card to the RPi
1. Connect keyboard and video to the RPi
1. Connect power to the RPi
1. Connect to WiFi
1. Configure country, keyboard, time zone
1. Change from default password
1. Allow new installation to install any updates
1. Open terminal window (<Alt><Ctrl><T> keyboard combination)
1. type this command:  cat /proc/cpuinfo | grep Serial
   1. system will respond with something like this:
      
      ```
      Serial          : 00000000ccfeUVWX
      ```
      
      This is the serial number of the RPi's CPU.
      We'll use this to create a host name
      which is likely unique on our LAN.  (This is useful if we
      deploy several RPi computers on our LAN).  The new host name
      will be `rpiUVWX`, using the last four characters of the CPU
      serial number.  If the last four are not enough to be unique, try the 
      last five or six.  Or, make up your own name scheme.
1. open system configuration tool (`sudo raspi-config` or the GUI tool)
   1. change host name (under *Network Options*) to "rpiUVWX" as above
   1. allow these protocols (*Interfacing Options*):  
      SSH, VNC, I2C, 1-Wire
1. (optional) Configure your LAN's DHCPD and DNS servers for the new RPi
1. Reboot and verify RPi is available for login on your LAN

## Solder the GPIO header pins

The RPi Zero (and Zero W) do not come with header pins or sockets.
That decision (and expense and labor) is left to us.  It's a simple
job.  For me, it's easier to work with header pins, soldered to
my RPi motherboard.  This project will only need three pins
to connect the DHT22 sensor.  **But**, we'll solder in the
complete double row of pins as one unit.  That way, the pins are
parallel from the start and we have a complete set if we later 
decide to expand this project.

# Connect with a DHT22 sensor

I bought my DHT22 AM2302 Digital Temperature And Humidity Sensor from
a merchant on Ebay.  The four pins from the sensor were attached to 
a circuit board that provides the resistor.  The circuit board has three
pins, clearly marked **-**, **OUT**, **+** and a 3-wire ribbon cable with
header sockets on each end.  (note:  I have several DHT22 sensors from
the same vendor.   Each ribbon cable has a different color sequence.  So
much for standardizing on wire color here.  Do your best.)

## Wire in the sensor

We can connect the DHT22 directly to the GPIO:

DHT22 pin | RPi GPIO pin | description
---- | ---- | ----
**+** | pin 1 | 3.3V
**OUT** | pin 7 | GND, GPIO 4
**-** | pin 9 | GND, BCM 4, GPIO 4

## install the software for demonstration

Following a [nice guide from Adafruit](https://tutorials-raspberrypi.com/raspberry-pi-measure-humidity-temperature-dht11-dht22/)
and the noting the [GPIO pinout](https://pinout.xyz/#), we can
connect to our DHT22 sensor in just a few simple steps.

```
sudo apt-get update
sudo apt-get install build-essential python-dev python-openssl git
```

These might already be installed.  (For me, they were already installed.)
Good to confirm that by using these commands anyway.

Then, install some software to connect with the DHT22 and demonstrate
that it is working.  For me, this worked the very first time!  
Here's my session:

```
pi@rpiUVWX:~ $ cd Documents/
pi@rpiUVWX:~/Documents $ git clone https://github.com/adafruit/Adafruit_Python_DHT.git && cd Adafruit_Python_DHT
pi@rpiUVWX:~/Documents/Adafruit_Python_DHT $ sudo python setup.py install
pi@rpiUVWX:~/Documents/Adafruit_Python_DHT $ cd examples/
pi@rpiUVWX:~/Documents/Adafruit_Python_DHT/examples $ ./AdafruitDHT.py 22 4
Temp=21.9*  Humidity=40.1%
```

## Logging

The demo code is great for testing basic connectivity but we
need to make our own code to log values.  We need each reading to
be time-stamped, synchronous with the report.  One 
[tutorial](https://tutorials-raspberrypi.com/raspberry-pi-measure-humidity-temperature-dht11-dht22/)
shows how to log data to a remote server ([ThingSpeak](https://thingspeak.com/)).
The authors have written a [tutorial](https://www.hackster.io/adamgarbo/raspberry-pi-2-iot-thingspeak-dht22-sensor-b208f4)
showing how to get started with logging data using the ThingSpeak service.

For *this* project, we choose to keep all the data on our own LAN
and not use data storage in the cloud.

We can easily create logging code with our specifications 
using Python.  We'll call the `AdafruitDHT.py`
routines to read from the sensor.  Here's an example:

```
#!/usr/bin/env python

import datetime
import sys
import time
import Adafruit_DHT

GPIO_PIN=4
SENSOR_MODEL=22
MINIMUM_WAIT_TIME=2.0
SLEEP_TIME=0.01

t_next=time.time()-1

while True:
	if time.time() >= t_next:
		humidity, temperature = Adafruit_DHT.read_retry(SENSOR_MODEL, GPIO_PIN)
		if humidity is not None and temperature is not None:
			f = str(datetime.datetime.now())
			f += '\t{0:0.1f}'.format(temperature)
			f += '\t{0:0.1f}'.format(humidity)
			print(f)
			sys.stdout.flush()
		t_next = time.time() + MINIMUM_WAIT_TIME
	else:
		time.sleep(SLEEP_TIME)
```

## Unattended logging

To run our Python code in an unattended manner, we need it stay running,
even after we logout (now shutdown).  That's the job of the `screen` 
program.  First, install it:

```
sudo apt-get install screen
```


## Automatic logging after reboot

To make this software run atuomatically after reboot,
we'll write a shell script that will start the logging.
An additional feature of the shell script is to check that
the logging is running and restart logging if the software
has stopped.  We can run this script periodically (say, every
five minutes) by adding it as a `cron` task.

One [suggestion](https://unix.stackexchange.com/questions/107939/how-to-restart-the-python-script-automatically-if-it-is-killed-or-dies)
involves writing a `cron` command that runs periodically.

We have a more
[robust script](https://github.com/APS-2BM-MIC/ipython-user2bmb/blob/master/profile_2bmb/startup/ioc2bmbmona/2bmbmona.sh)
which could break but, in practice, works well.  It will need just
a bit of modification for our project.  We'll call it `manage.sh` since it
will manage our logging process.  It's a bit long so we just refer you to the file
in this directory.

```
#=====================
# call periodically (every 5 minutes) to see if process is running
#=====================
#      field      allowed values
#      -----      --------------
#      minute     0-59
#      hour       0-23
#      day of month   1-31
#      month      1-12 (or names, see below)
#      day of week    0-7 (0 or 7 is Sun, or use names)

*/5 * * * * /home/pi/Documents/Adafruit_Python_DHT/examples/manage.sh checkup 2>&1 > /dev/null
```

We also need to modify our Python code to have it append new data
directly to the designated log file.  The new file:

```
#!/usr/bin/env python

import datetime
import sys
import time
import Adafruit_DHT

GPIO_PIN=4
SENSOR_MODEL=22
MINIMUM_WAIT_TIME=2.0
SLEEP_TIME=0.01

t_next = 0

fp = None
if len(sys.argv) > 1:
	fp = open(sys.argv[1], "a")
	
while True:
	if time.time() >= t_next:
		humidity, temperature = Adafruit_DHT.read_retry(SENSOR_MODEL, GPIO_PIN)
		if humidity is not None and temperature is not None:
			f = str(datetime.datetime.now())
			f += '\t{0:0.1f}'.format(temperature)
			f += '\t{0:0.1f}'.format(humidity)
			print(f)
			sys.stdout.flush()
			if fp is not None:
				fp.write(f)
				fp.write("\n")
				fp.flush()
		t_next = time.time() + MINIMUM_WAIT_TIME
	else:
		time.sleep(SLEEP_TIME)
```

# Logging and visualizing logged data

* ThingSpeak data logging service
* text files and spreadsheet (or gnuplot) graphing
* Matplotlib
* rrdtool
* EPICS
* EPICS and bluesky/databroker + visualizing
* EPICS and phoebus
