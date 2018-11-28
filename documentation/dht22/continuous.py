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
