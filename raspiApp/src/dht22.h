/*
 * dht22.h
 * */

#define READING_INVALID  -12.345e6
#define STATUS_NO_ERROR  0
#define STATUS_INVALID   1
#define WIRINGPI_SETUP_FAILURE   -1

static int read_dht22_dat(int, float *, float *);
