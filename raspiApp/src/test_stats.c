/*
 * test_stats.c
 *
 * unit tests for stats.c
 */

/* TODO: convert into unit test code */

#include <stdio.h>
#include "stats.h"

int main(int argc,char *argv[])
{
   SR_StatsRegisters reg1;

   reg1.x = 5.0;
   printf("Hello World\n");
   printf("x: %g\n", reg1.x);

   SR_SumClr(&reg1);
   printf("SumClr()\nx: %g\n", reg1.x);

   SR_SumAdd(&reg1, 0, 1);
   SR_SumAdd(&reg1, 1, 3);
   printf("sum:x = %g\n", reg1.x);
   printf("sum:y = %g\n", reg1.y);
   printf("sum:weight = %g\n", reg1.weight);

   SR_SumSub(&reg1, 0.5, 0.5);
   printf("sum:x = %g\n", reg1.x);
   printf("sum:y = %g\n", reg1.y);
   printf("sum:weight = %g\n", reg1.weight);
   printf("avg:x = %g\n", SR_MeanX(&reg1));
   printf("avg:y = %g\n", SR_MeanY(&reg1));
   printf("intercept = %g\n", SR_LR_intercept(&reg1));
   printf("slope = %g\n", SR_LR_slope(&reg1));

   return(0);
}

