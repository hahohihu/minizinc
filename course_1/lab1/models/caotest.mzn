var 1..9: C;
var 0..9: A;
var 0..9: O = 0;
var 1..9: Z;
var 0..9: H;
var 0..9: I;
var 1..9: P = 3 * Z;
var 1..9: T;
var 0..9: E;
var 0..9: S;

constraint 2*O + 2*I + 20*A + 10*H + 10*P + 200*C + 100*Z = T + 10*S + 100*E + 1000*T;

include "alldifferent.mzn";
constraint alldifferent([C,A,O,Z,H,I,P,T,E,S]);

solve satisfy;
