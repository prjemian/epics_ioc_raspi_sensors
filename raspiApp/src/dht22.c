/*  dht22.c:
 *	Simple test program to test the wiringPi functions
 *	Based on the existing dht11.c
 *	Amended by technion@lolware.net
 */

#include <wiringPi.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/types.h>
#include <unistd.h>

#include "dht22.h"

#define MAXTIMINGS 85
static int DHTPIN = 0;
static int dht22_dat[5] = {0,0,0,0,0};

#define DELAY_MS 1000

/* sizecvt(read)
 * digitalRead() and friends from wiringpi are defined as returning a 
 * value < 256. However, they are returned as int() types. 
 * This is a safety function.
 */
static uint8_t sizecvt(const int read)
{
  if (read > 255 || read < 0)
  {
    printf("Invalid data from wiringPi library\n");
    exit(EXIT_FAILURE);
  }
  return (uint8_t)read;
}

/* read_dht22_dat(pin, &h, &t)
 * get humidity and temperature from the DHT22 on the given GPIO pin.
 */
static int read_dht22_dat(int dhtpin, float *h, float *t)
{
  uint8_t laststate = HIGH;
  uint8_t counter = 0;
  uint8_t j = 0, i;

  dht22_dat[0] = dht22_dat[1] = dht22_dat[2] = dht22_dat[3] = dht22_dat[4] = 0;

  // pull pin down for 18 milliseconds
  pinMode(dhtpin, OUTPUT);
  digitalWrite(dhtpin, HIGH);
  delay(10);
  digitalWrite(dhtpin, LOW);
  delay(18);
  // then pull it up for 40 microseconds
  digitalWrite(dhtpin, HIGH);
  delayMicroseconds(40); 
  // prepare to read the pin
  pinMode(dhtpin, INPUT);

  // detect change and read data
  for ( i=0; i< MAXTIMINGS; i++) {
    counter = 0;
    while (sizecvt(digitalRead(dhtpin)) == laststate) {
      counter++;
      delayMicroseconds(1);
      if (counter == 255) {
        break;
      }
    }
    laststate = sizecvt(digitalRead(dhtpin));

    if (counter == 255) break;

    // ignore first 3 transitions
    if ((i >= 4) && (i%2 == 0)) {
      // shove each bit into the storage bytes
      dht22_dat[j/8] <<= 1;
      if (counter > 16)
        dht22_dat[j/8] |= 1;
      j++;
    }
  }

  // check we read 40 bits (8bit x 5 ) + verify checksum in the last byte
  // print it out if data is good
  if ((j >= 40) && 
      (dht22_dat[4] == ((dht22_dat[0] + dht22_dat[1] + dht22_dat[2] + dht22_dat[3]) & 0xFF)) ) {
        /* float t, h; */
        *h = (float)dht22_dat[0] * 256 + (float)dht22_dat[1];
        *h /= 10;
        *t = (float)(dht22_dat[2] & 0x7F)* 256 + (float)dht22_dat[3];
        *t /= 10.0;
        if ((dht22_dat[2] & 0x80) != 0)  *t *= -1;


    /*printf("Humidity = %.2f %% Temperature = %.2f *C \n", *h, *t );*/
    return STATUS_NO_ERROR;
  }
  /*else
  {
    printf("Data not good, skip\n");
    return 0;
  }*/
  return STATUS_INVALID;
}

/* main(argc, argv)
 */
int main (int argc, char *argv[])
{
  int tries = -1;
  float h = READING_INVALID, t = READING_INVALID;

  if (argc < 2) {
    printf ("usage: %s <pin> (<tries>)\n", argv[0]);
    printf ("description: pin is the wiringPi pin number\n");
    printf ("using PIN %d (GPIO ?)\n", DHTPIN);
    printf ("Optional: tries is the number of times to try to obtain a read (default: infinite)\n");
  } else
    DHTPIN = atoi(argv[1]);
   

  if (argc == 3)
    tries = atoi(argv[2]);

  if (tries == 0) {
    printf("Invalid tries supplied\n");
    exit(EXIT_FAILURE);
  }

  printf ("Raspberry Pi wiringPi DHT22 reader\nwww.lolware.net\n") ;

  if (wiringPiSetup () == WIRINGPI_SETUP_FAILURE)
    exit(EXIT_FAILURE) ;
	
  if (setuid(getuid()) < 0)
  {
    perror("Dropping root privileges failed\n");
    exit(EXIT_FAILURE);
  }

  while (tries != 0) 
  {
     if (read_dht22_dat(DHTPIN, &h, &t) == STATUS_NO_ERROR)
        printf("pin: %d  T = %.2f F  humidity = %.2f %%\n", 
            DHTPIN, t * 9./5.+32., h);
     /* else
        printf("%d: reading invalid\n", tries+1); */
     if (tries > 0) {
         tries--;
         delay(DELAY_MS); // wait 1sec to refresh
    }
  }

  return 0 ;
}
