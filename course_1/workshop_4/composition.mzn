int: n;

set of int: NOTE = 1..n;
set of int: DIFF = 1..n-1;
array[1..n] of var NOTE: order;
array[1..n-1] of var DIFF: diffs = [abs(order[i+1] - order[i]) | i in 1..n-1];

array[NOTE] of var 1..n: posn;
array[DIFF] of var 1..n-1: dposn;
constraint abs(posn[1] - posn[n]) = 1;
constraint dposn[n-1] = min(posn[1], posn[n]);

include "inverse.mzn";
constraint inverse(order, posn);
constraint inverse(diffs, dposn);

solve satisfy;

output [ "\(order)\n\(diffs)" ]
