/* stats.c
 *
 * calculator-style statistics registers
 */

/*
 * TODO: re-write in c++
 */

#include <math.h>
#include "stats.h"


void SumClr (stats_registers reg)
{
    reg.sum_weight = 0.0;
    reg.sum_x = 0.0;
    reg.sum_x2 = 0.0;
    reg.sum_y = 0.0;
    reg.sum_y2 = 0.0;
    reg.sum_xy = 0.0;
}

void SumAdd (double x, double y)
{
    SwtAdd (x, y, (double) 1.0);    /* unit weighting */
}

void SwtAdd (double x, double y, double z)
{
    double weight = 1/(z*z);
    double xWt = x * weight;
    double yWt = y * weight;
    sum_weight  += weight;
    sum_x       += xWt;
    sum_x2      += xWt*xWt;
    sum_y       += yWt;
    sum_y2      += yWt*yWt;
    sum_xy      += xWt*yWt;
}

void SumSub (double x, double y)
{
    SwtSub (x, y, (double) 1.0);    /* unit weighting */
}

void SwtSub (double x, double y, double z)
{
    double weight = 1/(z*z);
    double xWt = x * weight;
    double yWt = y * weight;
    sum_weight  -= weight;
    sum_x       -= xWt;
    sum_x2      -= xWt*xWt;
    sum_y       -= yWt;
    sum_y2      -= yWt*yWt;
    sum_xy      -= xWt*yWt;
}

void MeanXY (double *xMean, double *yMean)
{
    *xMean = sum_x / sum_weight;
    *yMean = sum_y / sum_weight;
}

void SDevXY (double *xDev, double *yDev)
{
    *xDev = 0.0;
    if (sum_x2 > ((sum_x*sum_x)/sum_weight) )
        *xDev = sqrt (( sum_x2 - ( (sum_x*sum_x)/sum_weight) )/sum_weight);
    *yDev = 0.0;
    if (sum_y2 > ((sum_y*sum_y)/sum_weight) )
        *yDev = sqrt (( sum_y2 - ( (sum_y*sum_y)/sum_weight) )/sum_weight);
}

void SErrXY (double *xErr, double *yErr)
{
    *xErr = 0.0;
    if (sum_x2 > ((sum_x*sum_x)/sum_weight) )
        *xErr = sqrt (( sum_x2 - ( (sum_x*sum_x)/sum_weight) )/( sum_weight-1 ));
    *yErr = 0.0;
    if (sum_y2 > ((sum_y*sum_y)/sum_weight) )
        *yErr = sqrt (( sum_y2 - ((sum_y*sum_y)/sum_weight) )/( sum_weight-1 ));
}

void SumLR (double *slope, double *constant)
{
    double determ = (sum_weight*sum_x2 - sum_x*sum_x);
    *slope = (sum_weight*sum_xy - sum_x*sum_y) / determ;
    *constant = (sum_x2*sum_y - sum_x*sum_xy) / determ;
}

void VarLR (double *slope, double *constant)
{
    double determ = (sum_weight*sum_x2 - sum_x*sum_x);
    *slope = sqrt (sum_weight / determ);
    *constant = sqrt (sum_x2 / determ);
}

double CorLR ()
{
    double VarX = sum_weight * sum_x2 - sum_x*sum_x;
    double VarY = sum_weight * sum_y2 - sum_y*sum_y;
    return (sum_weight * sum_xy - sum_x*sum_y) / sqrt (VarX * VarY);
}

double CorCoe ()
{
    return -sum_x / sqrt (sum_weight * sum_x2);
}
