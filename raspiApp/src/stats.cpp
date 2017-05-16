// stats.c
//
// calculator-style statistics registers

#include <math.h>
#include "stats.h"

// TODO: documentation

void StatsRegisters::SumClr ()
{
    weight = 0.0;
    x = 0.0;
    xx = 0.0;
    y = 0.0;
    yy = 0.0;
    xy = 0.0;
}

void StatsRegisters::SumAdd (double x_val, double y_val)
{
    SwtAdd (x_val, y_val, (double) 1.0);    // unit weighting
}

void StatsRegisters::SwtAdd (double x_val, double y_val, double w_val)
{
    double w = 1/(w_val*w_val);
    double xWt = x_val * w;
    double yWt = y_val * w;
    weight  += w_val;
    x       += xWt;
    xx      += xWt*xWt;
    y       += yWt;
    yy      += yWt*yWt;
    xy      += xWt*yWt;
}

void StatsRegisters::SumSub (double x_val, double y_val)
{
    SwtSub (x_val, y_val, (double) 1.0);    // unit weighting
}

void StatsRegisters::SwtSub (double x_val, double y_val, double w_val)
{
    double w = 1/(w_val*w_val);
    double xWt = x_val * w;
    double yWt = y_val * w;
    weight  -= w_val;
    x       -= xWt;
    xx      -= xWt*xWt;
    y       -= yWt;
    yy      -= yWt*yWt;
    xy      -= xWt*yWt;
}

double StatsRegisters::MeanX ()
{
    return x / weight;
}

double StatsRegisters::MeanY ()
{
    return y / weight;
}

double StatsRegisters::SDevX ()
{
    double sdev = 0.0;
    if (xx > ((x*x)/weight) )
        sdev = sqrt (( xx - ( (x*x)/weight) )/weight);
    return sdev;
}

double StatsRegisters::SDevY ()
{
    double sdev = 0.0;
    if (yy > ((y*y)/weight) )
        sdev = sqrt (( yy - ( (y*y)/weight) )/weight);
    return sdev;
}

double StatsRegisters::SErrX ()
{
    double serr = 0.0;
    if (xx > ((x*x)/weight) )
        serr = sqrt (( xx - ( (x*x)/weight) )/( weight-1 ));
    return serr;
}

double StatsRegisters::SErrY ()
{
    double serr = 0.0;
    if (yy > ((y*y)/weight) )
        serr = sqrt (( yy - ((y*y)/weight) )/( weight-1 ));
    return serr;
}

double StatsRegisters::Determinant ()
{
    return (weight*xx - x*x);
}

double StatsRegisters::LR_intercept ()
{
    return (xx*y - x*xy) / Determinant();
}

double StatsRegisters::LR_slope ()
{
    return (weight*xy - x*y) / Determinant();
}

double StatsRegisters::LR_intercept_var ()
{
    return sqrt (xx / Determinant());
}

double StatsRegisters::LR_slope_var ()
{
    return sqrt (weight / Determinant());
}

double StatsRegisters::CorLR ()
{
    double VarX = weight * xx - x*x;
    double VarY = weight * yy - y*y;
    return (weight * xy - x*y) / sqrt (VarX * VarY);
}

double StatsRegisters::CorCoe ()
{
    return -x / sqrt (weight * xx);
}
