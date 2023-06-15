% SOLUTION FORMAT CHECKER: DO NOT EDIT!!!

% --- DATA INPUT ---
enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
set of int: STEP = 1..min([length(legs), length(arms), length(face)]);
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;
int: boredom;

% --- GRADER INPUT ---
int: len;
array[int] of LEGS: legs;
array[int] of ARMS: arms;
array[int] of FACE: face;
int: _objective;

% --- SUCCESS MESSAGE ---
output["SUCCESS: Your model contains all variables required by the grader!"];
