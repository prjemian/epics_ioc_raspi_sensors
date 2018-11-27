/*
 * dht22.h
 * */

#define READING_INVALID  -12.345e6
#define STATUS_NO_ERROR  0
#define STATUS_INVALID   1
#define WIRINGPI_SETUP_FAILURE   -1

int read_dht22_dat(int dhtpin, float *h, float *t);

#define HUMIDITY_RANGE_HI      100
#define HUMIDITY_RANGE_LO        0
#define TEMPERATURE_RANGE_HI    80
#define TEMPERATURE_RANGE_LO   -20
