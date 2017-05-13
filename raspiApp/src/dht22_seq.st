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

/* #include <wiringPi.h> /* see issue #11 */
%%int  wiringPiSetup      (void) ;

#include "seqPVmacros.h"

/* #include "dht22.h"   /* see issue #11 */
%% int read_dht22_dat(int dhtpin, float *h, float *t);
#define READING_INVALID  -12.345e6
#define STATUS_NO_ERROR  0
#define STATUS_INVALID   1
#define WIRINGPI_SETUP_FAILURE   -1

int wiringPi_pin;


PV(int, available, "{P}pin{C}:available",   NoMon);
PV(int, status,    "{P}pin{C}:status",      NoMon);
PV(float, t,       "{P}pin{C}:temperature", NoMon);
PV(float, h,       "{P}pin{C}:humidity",    NoMon);

char msg[256];
char* SNLtaskName;


ss dht22_seq
{

    state init
    {
        when()
        {
            SNLtaskName = macValueGet("name");
            wiringPi_pin = atoi(macValueGet("C"));

            PVPUT(status, wiringPiSetup());
            PVPUT(available, !status);

        } state reading

    }

    state reading
    {

        when(available)
        {
            PVPUT(status, read_dht22_dat(wiringPi_pin, &h, &t));
            
            if (status == STATUS_NO_ERROR) {
                PVPUT(h, h);
                PVPUT(t, t);
            }

        } state idle

        when(!available) {} state idle

    }

    state idle
    {
        when( delay(1.) && available )
        {
        } state reading

        when( delay(.1) && available ) {} state idle
    }

}
