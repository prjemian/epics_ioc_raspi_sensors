// stats.h
//
// calculator-style statistics registers

// TODO: documentation

class StatsRegisters {

   public:
    double weight;	// sum of weights
    double x;		// sum of x
    double xx;		// sum of x^2
    double y;		// sum of y
    double yy;		// sum of y^2
    double xy;		// sum of x*y

	void SumClr ();      // clear the stats registers
	void SumAdd (double, double);       // add an X,Y pair
	void SumSub (double, double);       // remove an X,Y pair
	void SwtAdd (double,double,double); // add an X,Y pair with weight Z
	void SwtSub (double,double,double); // remove an X,Y pair with weight Z
	double MeanX ();   					// arithmetic mean of X
	double MeanY ();   					// arithmetic mean of Y
	double SDevX ();   					// standard deviation of X
	double SDevY ();   					// standard deviation of Y
	double SErrX ();   					// standard error of X
	double SErrY ();   					// standard error of Y
	double LR_intercept ();    		// constant term of linear regression
	double LR_slope ();    			// slope term of linear regression
	double LR_intercept_var ();    	// variance of constant term
	double LR_slope_var ();    		// variance of slope term
	double CorLR ();                    // the regression coefficient
	double CorCoe ();                   // relation of errors in slope & intercept

   	double Determinant ();
};
