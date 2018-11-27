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

%%#include <math.h>
%%#include <stdio.h>
%%#include <stdlib.h>
%%#include <time.h>
%%#include <unistd.h>
%%#include "stats.h"

/* #include <wiringPi.h> /* see issue #11 */
%%int  wiringPiSetup      (void) ;

#include "seqPVmacros.h"

/* #include "dht22.h"   /* see issue #11 */
%%int read_dht22_dat(int dhtpin, float *h, float *t);
#define READING_INVALID  -12.345e6
#define STATUS_NO_ERROR  0
#define STATUS_INVALID   1
#define WIRINGPI_SETUP_FAILURE   -1
#define DHT22_MINIMUM_READING_INTERVAL_S   2.0

#define SECONDS_1M 60
#define SECONDS_15M (SECONDS_1M*15)
#define SECONDS_60M (SECONDS_1M*60)

int wiringPi_pin;
%{
SR_StatsRegisters sr_1m;
SR_StatsRegisters sr_15m;
SR_StatsRegisters sr_60m;

time_t time_now;
time_t timer_1m;
time_t timer_15m;
time_t timer_60m;
time_t timer_reading;
}%

int report_on_1m  = 1;
int report_on_15m = 1;
int report_on_60m = 1;
int take_reading  = 1;

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

%{
            SR_SumClr(&sr_1m);
            SR_SumClr(&sr_15m);
            SR_SumClr(&sr_60m);

            time_now = time(NULL);
            timer_reading = time_now;
            /* update these early, the first time around */
            timer_1m = time_now + 1;
            timer_15m = time_now + 1;
            timer_60m = time_now + 1;
}%

        } state loop

    }

    state loop
    {
        when( available && take_reading )
        {
%%          time_now = time(NULL);
%%			timer_reading = time_now + DHT22_MINIMUM_READING_INTERVAL_S;
			take_reading = 0;
        } state reading

        when( available && report_on_1m )
        {
%%			time_now = time(NULL);
			printf("%s (%d) %s  %g readings\n", 
				SNLtaskName, __LINE__, "1m update", sr_1m.weight);
			if (sr_1m.weight > 0) {

%{
                pVar->h_1m = SR_MeanX(&sr_1m);
                pVar->t_1m = SR_MeanY(&sr_1m);
                pVar->h_sdev_1m = SR_SDevX(&sr_1m);
                pVar->t_sdev_1m = SR_SDevY(&sr_1m);
				SR_SumClr(&sr_1m);
}%

                pvPut(h_1m,SYNC);
                pvPut(t_1m,SYNC);
                pvPut(h_sdev_1m,SYNC);
                pvPut(t_sdev_1m,SYNC);
            }
			report_on_1m = 0;
%%			timer_1m = (1 + time_now/SECONDS_1M)*SECONDS_1M;
        } state loop

        when( available && report_on_15m )
        {
%%			time_now = time(NULL);
			printf("%s (%d) %s  %g readings\n", 
				SNLtaskName, __LINE__, "15m update", sr_15m.weight);
			if (sr_15m.weight > 0) {

%{
                pVar->h_15m = SR_MeanX(&sr_15m);
                pVar->t_15m = SR_MeanY(&sr_15m);
                pVar->h_sdev_15m = SR_SDevX(&sr_15m);
                pVar->t_sdev_15m = SR_SDevY(&sr_15m);
				SR_SumClr(&sr_15m);
}%

                pvPut(h_15m,SYNC);
                pvPut(t_15m,SYNC);
                pvPut(h_sdev_15m,SYNC);
                pvPut(t_sdev_15m,SYNC);
            }
			report_on_15m = 0;
%%			timer_15m = (1 + time_now/SECONDS_15M)*SECONDS_15M;

        } state loop

        when( available && report_on_60m )
        {
%%			time_now = time(NULL);
			printf("%s (%d) %s  %g readings\n", 
				SNLtaskName, __LINE__, "60m update", sr_60m.weight);
			if (sr_60m.weight > 0) {

%{
                pVar->h_60m = SR_MeanX(&sr_60m);
                pVar->t_60m = SR_MeanY(&sr_60m);
                pVar->h_sdev_60m = SR_SDevX(&sr_60m);
                pVar->t_sdev_60m = SR_SDevY(&sr_60m);
				SR_SumClr(&sr_60m);
}%

                pvPut(h_60m,SYNC);
                pvPut(t_60m,SYNC);
                pvPut(h_sdev_60m,SYNC);
                pvPut(t_sdev_60m,SYNC);
            }
			report_on_60m = 0;
%%			timer_60m = (1 + time_now/SECONDS_60M)*SECONDS_60M;
        } state loop

        when( available && delay(.1) ) {
%{
			time_now = time(NULL);
			pVar->take_reading  = (time_now >= timer_reading);
			pVar->report_on_1m  = (time_now >= timer_1m);
			pVar->report_on_15m = (time_now >= timer_15m);
			pVar->report_on_60m = (time_now >= timer_60m);
}%
        } state loop
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
                SR_SumAdd(&sr_1m, h, t);
                SR_SumAdd(&sr_15m, h, t);
                SR_SumAdd(&sr_60m, h, t);
            }

        } state loop

        when(!available) {} state loop

    }

}
