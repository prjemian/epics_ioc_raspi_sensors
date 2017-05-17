/* stats.c
 *
 * calculator-style statistics registers
 */

#include <math.h>
#include "stats.h"

/* TODO: documentation */

void SR_SumClr (SR_StatsRegisters *sr)
{
    sr->weight = 0.0;
    sr->x = 0.0;
    sr->xx = 0.0;
    sr->y = 0.0;
    sr->yy = 0.0;
    sr->xy = 0.0;
}

void SR_SumAdd (SR_StatsRegisters *sr, double x_val, double y_val)
{
    SR_SwtAdd (sr, x_val, y_val, (double) 1.0);    // unit weighting
}

void SR_SwtAdd (SR_StatsRegisters *sr, double x_val, double y_val, double w_val)
{
    double w = 1/(w_val*w_val);
    double xWt = x_val * w;
    double yWt = y_val * w;
    sr->weight  += w_val;
    sr->x       += xWt;
    sr->xx      += xWt*xWt;
    sr->y       += yWt;
    sr->yy      += yWt*yWt;
    sr->xy      += xWt*yWt;
}

void SR_SumSub (SR_StatsRegisters *sr, double x_val, double y_val)
{
    SR_SwtSub (sr, x_val, y_val, (double) 1.0);    // unit weighting
}

void SR_SwtSub (SR_StatsRegisters *sr, double x_val, double y_val, double w_val)
{
    double w = 1/(w_val*w_val);
    double xWt = x_val * w;
    double yWt = y_val * w;
    sr->weight  -= w_val;
    sr->x       -= xWt;
    sr->xx      -= xWt*xWt;
    sr->y       -= yWt;
    sr->yy      -= yWt*yWt;
    sr->xy      -= xWt*yWt;
}

double SR_MeanX (SR_StatsRegisters *sr)
{
    return sr->x / sr->weight;
}

double SR_MeanY (SR_StatsRegisters *sr)
{
    return sr->y / sr->weight;
}

double SR_SDevX (SR_StatsRegisters *sr)
{
    double sdev = 0.0;
    if (sr->xx > ((sr->x*sr->x)/sr->weight) )
        sdev = sqrt (( sr->xx - ( (sr->x*sr->x)/sr->weight) )/sr->weight);
    return sdev;
}

double SR_SDevY (SR_StatsRegisters *sr)
{
    double sdev = 0.0;
    if (sr->yy > ((sr->y*sr->y)/sr->weight) )
        sdev = sqrt (( sr->yy - ( (sr->y*sr->y)/sr->weight) )/sr->weight);
    return sdev;
}

double SR_SErrX (SR_StatsRegisters *sr)
{
    double serr = 0.0;
    if (sr->xx > ((sr->x*sr->x)/sr->weight) )
        serr = sqrt (( sr->xx - ( (sr->x*sr->x)/sr->weight) )/( sr->weight-1 ));
    return serr;
}

double SR_SErrY (SR_StatsRegisters *sr)
{
    double serr = 0.0;
    if (sr->yy > ((sr->y*sr->y)/sr->weight) )
        serr = sqrt (( sr->yy - ((sr->y*sr->y)/sr->weight) )/( sr->weight-1 ));
    return serr;
}

double SR_Determinant (SR_StatsRegisters *sr)
{
    return (sr->weight*sr->xx - sr->x*sr->x);
}

double SR_LR_intercept (SR_StatsRegisters *sr)
{
    return (sr->xx*sr->y - sr->x*sr->xy) / SR_Determinant(sr);
}

double SR_LR_slope (SR_StatsRegisters *sr)
{
    return (sr->weight*sr->xy - sr->x*sr->y) / SR_Determinant(sr);
}

double SR_LR_intercept_var (SR_StatsRegisters *sr)
{
    return sqrt (sr->xx / SR_Determinant(sr));
}

double SR_LR_slope_var (SR_StatsRegisters *sr)
{
    return sqrt (sr->weight / SR_Determinant(sr));
}

double SR_CorLR (SR_StatsRegisters *sr)
{
    double VarX = sr->weight * sr->xx - sr->x*sr->x;
    double VarY = sr->weight * sr->yy - sr->y*sr->y;
    return (sr->weight * sr->xy - sr->x*sr->y) / sqrt (VarX * VarY);
}

double SR_CorCoe (SR_StatsRegisters *sr)
{
    return -sr->x / sqrt (sr->weight * sr->xx);
}
