/* stats.h
 *
 * calculator-style statistics registers
 *
 * All functions prefixed with `SR_`
 */

/* TODO: documentation */

typedef struct StatsRegisters_struct {
    double weight;	/* sum of weights */
    double x;		/* sum of x */
    double xx;		/* sum of x^2 */
    double y;		/* sum of y */
    double yy;		/* sum of y^2 */
    double xy;		/* sum of x*y */
} SR_StatsRegisters;

void SR_SumClr (SR_StatsRegisters *);      // clear the stats registers
void SR_SumAdd (SR_StatsRegisters *, double, double);       // add an X,Y pair
void SR_SumSub (SR_StatsRegisters *, double, double);       // remove an X,Y pair
void SR_SwtAdd (SR_StatsRegisters *, double,double,double); // add an X,Y pair with weight Z
void SR_SwtSub (SR_StatsRegisters *, double,double,double); // remove an X,Y pair with weight Z
double SR_MeanX (SR_StatsRegisters *);   					// arithmetic mean of X
double SR_MeanY (SR_StatsRegisters *);   					// arithmetic mean of Y
double SR_SDevX (SR_StatsRegisters *);   					// standard deviation of X
double SR_SDevY (SR_StatsRegisters *);   					// standard deviation of Y
double SR_SErrX (SR_StatsRegisters *);   					// standard error of X
double SR_SErrY (SR_StatsRegisters *);   					// standard error of Y
double SR_LR_intercept (SR_StatsRegisters *);    		// constant term of linear regression
double SR_LR_slope (SR_StatsRegisters *);    			// slope term of linear regression
double SR_LR_intercept_var (SR_StatsRegisters *);    	// variance of constant term
double SR_LR_slope_var (SR_StatsRegisters *);    		// variance of slope term
double SR_CorLR (SR_StatsRegisters *);                    // the regression coefficient
double SR_CorCoe (SR_StatsRegisters *);                   // relation of errors in slope & intercept

double SR_Determinant (SR_StatsRegisters *);
