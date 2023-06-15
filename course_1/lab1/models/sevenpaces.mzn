var 1..9: S;
var 0..9: E;
var 1..9: V;
var 0..9: N;
var 1..9: P;
var 0..9: A;
var 0..9: C;
var 0..9: R;

var int: Verse = E + 10*S + 100*R + 1000*E + 10000*V;
constraint N + S + 20*E + 100*(V+C) + 1000*(E+A) + 10000*(S+P) = Verse;

include "alldifferent.mzn";
constraint alldifferent([S,E,V,N,P,A,C,R]);

solve maximize Verse;