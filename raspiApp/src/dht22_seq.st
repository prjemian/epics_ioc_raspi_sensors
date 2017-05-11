/*  dht22_seq - DHT22 humidity & temperature sensor
    Calling seqeunce:
        seq &dht22_seq,"name=,P=,C="
 
    Where:
        P  = prefix of database and sequencer
        C  = wiringPi PIN number (default: 0)

 */
program dht22_seq("name=femto,P=,C=")

option +d;
option -c;
option +r;
option -w;

%%#include <stdio.h>
%%#include <math.h>
%%#include "dht22.h"
#include "seqPVmacros.h"


PV(float, t,    "{P}pin{C}:temperature", NoMon);
PV(float, h,    "{P}pin{C}:humidity",    NoMon);
PV(int, status, "{P}pin{C}:status",      NoMon);

int available;

char msg[256];
char* SNLtaskName;


ss dht22_seq
{

    state init
    {
        when()
        {
            SNLtaskName = macValueGet("name");

            %%status = wiringPiSetup ();
            PVPUT(status, status);
            available = !status;

            DEBUG_PRINT(2,"init complete");
        } state reading

    }

    state reading
    {
        when(!available) {} state idle

        when(available)
        {
            %%status == read_dht22_dat(DHTPIN, &h, &t);
            
            PVPUT(status, status);
            
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
