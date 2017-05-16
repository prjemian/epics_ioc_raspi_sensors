// test_stats.cpp
//
// unit tests for stats.cpp

// TODO: convert into unit test code

#include <iostream>
#include "stats.h"
using namespace std;

int main() {
   StatsRegisters reg1;

   reg1.x = 5.0;
   cout << "Hello World" << endl;
   cout << sizeof(reg1) << endl;
   cout << reg1.x << endl;

   reg1.SumClr();
   cout << reg1.x << endl;

   reg1.SumAdd(0, 1);
   reg1.SumAdd(1, 3);
   cout << "sum:x = " << reg1.x << endl;
   cout << "sum:y = " << reg1.y << endl;
   cout << "sum:weight = " << reg1.weight << endl;

   reg1.SumSub(0.5, 0.5);
   cout << "sum:x = " << reg1.x << endl;
   cout << "sum:y = " << reg1.y << endl;
   cout << "sum:weight = " << reg1.weight << endl;
   cout << "avg:x = " << reg1.MeanX() << endl;
   cout << "avg:y = " << reg1.MeanY() << endl;
   cout << "intercept = " << reg1.LR_intercept() << endl;
   cout << "slope = " << reg1.LR_slope() << endl;

   return 0;
}

