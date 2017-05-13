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
program dht22_seq("name=dht22_seq,P=,C=")

option +d;		/* turn on run-time debugging messages */
/* option -c;		/* continue execution before all PVs connected */
option +r;		/* allow more than one instance of this code */
option -w;		/* Suppress warnings */

%%#include <stdio.h>
%%#include <math.h>
#include <wiringPi.h>

#include "dht22.h"
#include "seqPVmacros.h"

#define DHTPIN 0


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

            PVPUT(status, wiringPiSetup());
            PVPUT(available, !status);

        } state reading

    }

    state reading
    {
        when(!available) {} state idle

        when(available)
        {
            PVPUT(status, read_dht22_dat(DHTPIN, &h, &t));
            
            if (status == STATUS_NO_ERROR) {
                PVPUT(h, h);
                PVPUT(t, t);
            }

        } state idle

    }

    state idle
    {
        when( delay(1.) && available )
        {
        } state reading

        when( delay(.1) && available ) {} state idle
    }

}
