# Example interface using EPICS softIoc

This is an example that is minimal on the EPICS setup yet 
nearly as full-featured as the original example.  It relies 
on the same support from Adafruit as described 
[previously](https://github.com/prjemian/epics_ioc_raspi_sensors/blob/master/documentation/dht22/notes.md).

## OS version : raspbian buster

This time, the project starts with the most recent raspbian release 
(*buster*: as of writing 2020-02-23):

```
pi@raspberrypi:~ $ more /etc/os-release 
PRETTY_NAME="Raspbian GNU/Linux 10 (buster)"
NAME="Raspbian GNU/Linux"
VERSION_ID="10"
VERSION="10 (buster)"
VERSION_CODENAME=buster
ID=raspbian
ID_LIKE=debian
HOME_URL="http://www.raspbian.org/"
SUPPORT_URL="http://www.raspbian.org/RaspbianForums"
BUG_REPORT_URL="http://www.raspbian.org/RaspbianBugs"
```

## EPICS base version : 7.0.3.1

The latests EPICS base was [downloaded](https://epics.anl.gov/base/R7-0/3.php) 
and built on the RPi with these parameters:

```
EPICS_BASE_DIR=/usr/local/epics/base-7.0.3.1
EPICS_HOST_ARCH=linux-arm
EPICS_ROOT=/usr/local/epics
EPICS_BASE_LIB=/usr/local/epics/base-7.0.3.1/lib/linux-arm
EPICS_BASE_BIN=/usr/local/epics/base-7.0.3.1/bin/linux-arm
```

`EPICS_BASE_BIN` was added to the `PATH` so that `caget`, `caput`,
`camonitor`, `cainfo`, and `softIoc` would be found by default.

NOTE: Any version of EPICS could be used, as far back as 3.14.?. 
All that is needed is the `softIoc` program and records that are
supplied with EPICS base.

## EPICS IOC: P=gbr:, S=

In this example, `gbr:` is a prefix for PVs chosen to not duplicate 
any existing EPICS process variables on our local area network.
Use any prefix you wish.  Just avoid making duplicate PVs.

Start the EPICS IOC on the RPi 
[in a `screen` session](https://github.com/prjemian/epics_ioc_raspi_sensors/blob/master/documentation/dht22/notes.md#unattended-logging):
`softIoc -d dht22-softIoc.db -m "P=gbr:,S=s1:"`

### about the database

The [EPICS database](https://github.com/prjemian/epics_ioc_raspi_sensors/blob/master/raspiApp/Db/dht22-softIoc.db) 
provides PVs for the current humidity and temperature.
These values are obtained directly from the DHT22 sensor by a python
program that runs outside of the EPICS IOC.  It is an EPICS *client* program.

We want to use an EPICS IOC for this example since it provides a rich set
of features for sensor monitoring and signal averaging.

For both humidity and temperature, a fresh value is obtained from the DHT22.
The *raw* value is also smoother in three other records with varying degrees
of smoothness factor.  The calculations are triggered by the use of EPICS
forward links (`FLNK`) to direct the processing of the next record.
The processing chain is:

    raw -> s80 -> s95 -> s99
    noisy   ---->  smoothest

The EPICS `ai` record provides input
[smoothing](https://wiki-ext.aps.anl.gov/epics/index.php/RRM_3-14_Analog_Input#Read_and_Convert_Parameters).
A factor (`SMOO`) is specified for the PV.  The pattern is `:s80` has `SMOO=0.80`.  
(The lower number corresponds to less smoothing.)

## Read sensor & update EPICS

This is the easy part since just about all the work has been done by others.
We use the Adafruit Python library as described 
[before](https://github.com/prjemian/epics_ioc_raspi_sensors/blob/master/documentation/dht22/notes.md#install-the-software-for-demonstration).

A simple [program](https://github.com/prjemian/epics_ioc_raspi_sensors/blob/master/raspiApp/Db/dht22-softIoc.py) to read the DHT22 and update EPICS
is constructed with the [pyepics](https://cars9.uchicago.edu/software/python/pyepics3/) library.

After installing *PyEpics* (`pip install pyepics`), run that program in a screen session: `python dht22-softIoc.py`.

## data collection

The EPICS community has a rich set of software tools for data collection.
Here, we use the [*Bluesky (python 3.6+) framework*](https://blueskyproject.io/)
to connect with EPICS and watch the temperature for some time.

### Connect Bluesky with EPICS

#### custom python *conda* virtual environment

We created a custom conda environment for data collection on a different Linux
workstation on our LAN using this [script](https://github.com/BCDA-APS/use_bluesky/blob/master/python_installation/setup_aps_2020_1.sh).
After downloading the script, we had to modify the *activate* command 
(`source /APSshare/miniconda/x86_64/bin/activate`) to find our local installation of
[Miniconda](https://www.anaconda.com/rpm-and-debian-repositories-for-miniconda/).

The RPi has [berryconda](https://github.com/jjhelmus/berryconda) 
but we did not use it this time.  Maybe for the future?

#### ophyd setup

The *ophyd* library connects to the EPICS system (using *PyEpics* under the hood).
We created an [ophyd structure](https://github.com/prjemian/epics_ioc_raspi_sensors/blob/master/raspiApp/Db/dht22-softIoc-ophyd.py)
to talk with the PVs from the database above.  The last line in this file creates the ophyd object we'll use to
plot the temperature *vs.* time.

Loading that object into our working bluesky ipython session,
the [`object_explorer`](https://apstools.readthedocs.io/en/latest/source/_utils.html#apstools.utils.object_explorer)
tool from [`apstools`](https://apstools.readthedocs.io/)
will show the structure and current values.

```
In [13]: object_explorer(gbr)                                                                                                               
=============== =================== ==================
name            PV reference        value             
=============== =================== ==================
description     gbr:description     DHT22 sensor      
humidity.raw    gbr:humidity        29.5              
humidity.s80    gbr:humidity:s80    29.55662351385635 
humidity.s95    gbr:humidity:s95    29.558898967125973
humidity.s99    gbr:humidity:s99    29.49643366181315 
temperature.raw gbr:temperature     29.899999618530273
temperature.s80 gbr:temperature:s80 29.8999741098647  
temperature.s95 gbr:temperature:s95 29.89720413969456 
temperature.s99 gbr:temperature:s99 29.924679671085695
=============== =================== ==================
```

#### Plot temperature *vs.* time

With a working [bluesky ipython session](https://github.com/prjemian/ipython-vm7)
configured and the `gbr` ophyd object connected with our EPICS IOC, a plot of
temperature *vs.* time results from this bluesky command:

    RE(bp.count([gbr.temperature], num=60*30, delay=2))
    
Updates from the sensor are at 2 second (or longer) intervals.  This
time scan runs for 1 hour (60 minutes * 30 readings at 2 second intervals).
