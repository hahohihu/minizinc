% SOLUTION FORMAT CHECKER: DO NOT EDIT!!!

% --- DATA INPUT ---
enum WARRIOR;
WARRIOR: dummy;
enum CLAN;

int: l;
int: u;
int: m;

array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;

% --- GRADER INPUT ---
set of WARRIOR: raid;
int: _objective;

% --- SUCCESS MESSAGE ---
output["SUCCESS: Your model contains all variables required by the grader!"];
