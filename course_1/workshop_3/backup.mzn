% Beauty Trap
% Perform the most seductive dance

enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
set of int: STEP = 1..maxlen;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");
array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;
constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");
int: boredom; % how bored each step make the viewer

var STEP: len;
array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;
include "global_cardinality_low_up.mzn";
constraint global_cardinality_low_up(legs, [l | l in LEGS], [0 | l in LEGS], maxlegs);
constraint global_cardinality_low_up(arms, [a | a in ARMS], [0 | a in ARMS], maxarms);
constraint global_cardinality_low_up(face, [f | f in FACE], [0 | f in FACE], maxface);

constraint [trace_exp(maxlen), trace_exp(len)] != [true, true];
constraint forall(i in len+1..maxlen)(trace_exp(i) != 0);
constraint forall(step in len+1..maxlen)(legs[step] = stand /\ arms[step] = neutral /\ face[step] = blank);

include "regular.mzn";
constraint regular(legs, 7, LEGS, leg_dfa, 1, 2..7);
array[1..7,LEGS] of 0..7: leg_dfa =
[|2,0,4,5,6,7 % init
 |0,0,0,5,6,7 % spin
 |2,0,4,0,0,7 % leap
 |2,0,4,5,6,7 % waltz
 |2,0,4,5,6,7 % curtsey
 |2,3,4,5,6,7 % prep
 |2,0,4,5,6,7 % stand
 |];
constraint forall(step in 1..maxlen-2)(legs[step] = waltz /\ legs[step+1] = waltz -> legs[step+2] != waltz);
constraint forall(step1 in 1..maxlen-2)(
  step1 = waltz ->
  forall(step3 in 1..maxlen)(
    step3 = curtsey ->
    exists(step2 in step1+1..step3-1)(step2 = stand)
  )
);

constraint regular(arms, 6, ARMS, arm_dfa, 1, 2..6);
array[1..6,ARMS] of 0..6: arm_dfa =
[|0,3,4,5,6 % init
 |0,3,4,5,6 % beckon
 |2,0,4,0,6 % out
 |2,3,0,0,6 % up
 |0,3,4,0,6 % wrapped
 |0,3,4,5,6 % neutral
 |];
 
constraint forall(step in 1..maxlen-2)(face[step] = face[step+1] /\ face[step] != blank -> face[step+1] != face[step+2]);
constraint forall(step in 1..maxlen-1)(face[step] = smile \/ face[step] = batt -> face[step+1] != think);
 
var int: obj = sum(step in STEP)(dance_value[legs[step], arms[step]] + entice_value[arms[step], face[step]]) - len * boredom;
solve maximize obj;

output [ "\(len)\n\(legs)\n\(arms)\n\(face)\n\(obj)" ]
