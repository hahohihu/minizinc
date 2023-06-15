int: maxlen = 10;
set of int: STEP = 1..maxlen;
var STEP: len;

constraint [trace_exp(maxlen), trace_exp(len)] != [true, true];
constraint forall(i in len+1..maxlen)(trace_exp(i) != 0);

solve satisfy;
