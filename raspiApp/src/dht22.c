/*  dht22.c:
 *  library for dht22 using wiringPi functions
 *  Based on the existing dht11.c
 *  Amended by technion@lolware.net
 */

#include <wiringPi.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/types.h>
#include <unistd.h>

#include "dht22.h"

#define MAXTIMINGS 85
static int dht22_dat[5] = {0,0,0,0,0};

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
int read_dht22_dat(int dhtpin, float *h, float *t)
{
  uint8_t laststate = HIGH;
  uint8_t counter = 0;
  uint8_t j = 0, i;

  dht22_dat[0] = dht22_dat[1] = dht22_dat[2] = dht22_dat[3] = dht22_dat[4] = 0;

  // initiate a reading
  pinMode(dhtpin, OUTPUT);    // transmit
  digitalWrite(dhtpin, HIGH); // clear the communications
  delay(10);
  digitalWrite(dhtpin, LOW);  // pull pin down for 18 milliseconds
  delay(18);

  digitalWrite(dhtpin, HIGH); // pull pin up for 40 microseconds
  delayMicroseconds(40);
  // prepare to read the pin
  pinMode(dhtpin, INPUT);     // receive

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
    /* printf("pin:%d  i=%d laststate:%d\n", dhtpin, i, laststate); */

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

  // check we received 40 bits (8bit x 5) & verify checksum in the last byte
  if ((j >= 40) && (dht22_dat[4] == ((dht22_dat[0] + dht22_dat[1] + dht22_dat[2] + dht22_dat[3]) & 0xFF)) ) {
    /* float t, h; */
    *h = (float)dht22_dat[0] * 256 + (float)dht22_dat[1];
    *h /= 10;
    *t = (float)(dht22_dat[2] & 0x7F)* 256 + (float)dht22_dat[3];
    *t /= 10.0;
    if ((dht22_dat[2] & 0x80) != 0)  *t *= -1;

    // invalid if out of range
    if (*t < TEMPERATURE_RANGE_LO) return STATUS_INVALID;
    if (*t > TEMPERATURE_RANGE_HI) return STATUS_INVALID;
    if (*h < HUMIDITY_RANGE_LO) return STATUS_INVALID;
    if (*h > HUMIDITY_RANGE_HI) return STATUS_INVALID;

    return STATUS_NO_ERROR;
  }
  return STATUS_INVALID;
}
