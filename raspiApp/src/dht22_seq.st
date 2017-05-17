/*  dht22_seq
 *
 *  DHT22 humidity & temperature sensor
 *
 *  Calling sequence:
 *      seq &dht22_seq,"name=,P=,C="
 *
 *  Where:
 *      P  = prefix of database and sequencer
 *      C  = wiringPi PIN number (default: 0)
 *
 */
 
program dht22_seq("name=dht22_seq,P=,C=0")

option +d;		/* turn on run-time debugging messages */
/* option -c;		/* continue execution before all PVs connected */
option +r;		/* allow more than one instance of this code */
option -w;		/* Suppress warnings */

%%#include <stdio.h>
%%#include <stdlib.h>
%%#include <math.h>
#include "stats.h"

/* #include <wiringPi.h> /* see issue #11 */
%%int  wiringPiSetup      (void) ;

#include "seqPVmacros.h"

/* #include "dht22.h"   /* see issue #11 */
%%int read_dht22_dat(int dhtpin, float *h, float *t);
#define READING_INVALID  -12.345e6
#define STATUS_NO_ERROR  0
#define STATUS_INVALID   1
#define WIRINGPI_SETUP_FAILURE   -1

int wiringPi_pin;


PV(int, available, "{P}{C}:available",   NoMon);
PV(int, status,    "{P}{C}:status",      NoMon);

PV(float, h,          "{P}{C}:humidity",          NoMon);
PV(float, h_1m,       "{P}{C}:humidity:1m",       NoMon);
PV(float, h_sdev_1m,  "{P}{C}:humidity:1m:sdev",  NoMon);
PV(float, h_15m,      "{P}{C}:humidity:15m",      NoMon);
PV(float, h_sdev_15m, "{P}{C}:humidity:15m:sdev", NoMon);
PV(float, h_60m,      "{P}{C}:humidity:60m",      NoMon);
PV(float, h_sdev_60m, "{P}{C}:humidity:60m:sdev", NoMon);

PV(float, t,          "{P}{C}:temperature",          NoMon);
PV(float, t_1m,       "{P}{C}:temperature:1m",       NoMon);
PV(float, t_sdev_1m,  "{P}{C}:temperature:1m:sdev",  NoMon);
PV(float, t_15m,      "{P}{C}:temperature:15m",      NoMon);
PV(float, t_sdev_15m, "{P}{C}:temperature:15m:sdev", NoMon);
PV(float, t_60m,      "{P}{C}:temperature:60m",      NoMon);
PV(float, t_sdev_60m, "{P}{C}:temperature:60m:sdev", NoMon);

PV(string, h_egu,          "{P}{C}:humidity.EGU",          Monitor);
PV(string, h_egu_1m,       "{P}{C}:humidity:1m.EGU",       Monitor);
PV(string, h_egu_sdev_1m,  "{P}{C}:humidity:1m:sdev.EGU",  Monitor);
PV(string, h_egu_15m,      "{P}{C}:humidity:15m.EGU",      Monitor);
PV(string, h_egu_sdev_15m, "{P}{C}:humidity:15m:sdev.EGU", Monitor);
PV(string, h_egu_60m,      "{P}{C}:humidity:60m.EGU",      Monitor);
PV(string, h_egu_sdev_60m, "{P}{C}:humidity:60m:sdev.EGU", Monitor);

PV(string, t_egu,          "{P}{C}:temperature.EGU",          Monitor);
PV(string, t_egu_1m,       "{P}{C}:temperature:1m.EGU",       Monitor);
PV(string, t_egu_sdev_1m,  "{P}{C}:temperature:1m:sdev.EGU",  Monitor);
PV(string, t_egu_15m,      "{P}{C}:temperature:15m.EGU",      Monitor);
PV(string, t_egu_sdev_15m, "{P}{C}:temperature:15m:sdev.EGU", Monitor);
PV(string, t_egu_60m,      "{P}{C}:temperature:60m.EGU",      Monitor);
PV(string, t_egu_sdev_60m, "{P}{C}:temperature:60m:sdev.EGU", Monitor);

char msg[256];
char* SNLtaskName;


ss dht22_seq
{

    state setup
    {
        when()
        {
            SNLtaskName = macValueGet("name");
            wiringPi_pin = atoi(macValueGet("C"));

            printf("DHT22 support started, task name: %s\n", SNLtaskName);
            printf("Expecting DHT22 on wiringPi pin %d\n", wiringPi_pin);

            PVPUT(status, wiringPiSetup());
            PVPUT(available, !status);

        } state reading

    }

    state loop
    {
        when( delay(1.) && available )
        {
        } state reading

        when( delay(.1) && !available ) {} state loop
    }

    state reading
    {

        when(available)
        {
            PVPUT(status, read_dht22_dat(wiringPi_pin, &h, &t));
            /* printf("%s read %d status: %d\n", SNLtaskName, wiringPi_pin, status); */
            
            if (status == STATUS_NO_ERROR) {
                /*
                printf("%s h = %g\n", SNLtaskName, h);
                printf("%s t = %g\n", SNLtaskName, t);
                */
                PVPUT(h, h);
                PVPUT(t, t);
            }

        } state loop

        when(!available) {} state loop

    }

}
