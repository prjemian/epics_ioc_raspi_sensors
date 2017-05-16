/* stats.c
 *
 * calculator-style statistics registers
 */

/* statistics registers */
struct stats_registers {
    double sum_weight;
    double sum_x;
    double sum_x2;
    double sum_y;
    double sum_y2;
    double sum_xy;
};

void SumClr (stats_registers);                     /* clear the stats registers */
void SumAdd (double, double);       /* add an X,Y pair */
void SumSub (double, double);       /* remove an X,Y pair */
void SwtAdd (double,double,double); /* add an X,Y pair with weight Z */
void SwtSub (double,double,double); /* remove an X,Y pair with weight Z */
void MeanXY (double *, double *);   /* arithmetic mean of X & Y */
void SDevXY (double *, double *);   /* standard deviation on X & Y */
void SErrXY (double *, double *);   /* standard error on X & Y */
void SumLR (double *, double *);    /* linear regression */
void VarLR (double *, double *);    /* est. errors of slope & intercept */
double CorLR ();                    /* the regression coefficient */
double CorCoe ();                   /* relation of errors in slope & intercept */
