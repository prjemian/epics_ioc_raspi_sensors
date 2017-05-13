/*  dht22_main.c:
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

static int DHTPIN = 0;
int status = -1;

#define DELAY_MS 1000


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
     status = read_dht22_dat(DHTPIN, &h, &t);
     /* printf("DHT22, pin %d read status: %d\n", DHTPIN, status); */
     if (status == STATUS_NO_ERROR)
        printf("pin: %d  T = %.2f F  humidity = %.2f %%\n", 
            DHTPIN, t * 9./5.+32., h);
     /* else
        printf("%d: reading invalid\n", tries+1); */
     if (tries > 0)
         tries--;
     if (tries != 0)
         delay(DELAY_MS); // wait 1sec to refresh
  }

  return 0 ;
}
