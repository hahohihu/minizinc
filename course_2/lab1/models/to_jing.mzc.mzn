% SOLUTION FORMAT CHECKER: DO NOT EDIT!!!

% --- DATA INPUT ---
int: nrow;
set of int: ROW = 1..nrow;
int: ncol;
set of int: COL = 1..ncol;

% Plains, Mountain, Forest, City, River
enum TERRAIN = { P, M, F, C, R };
array[TERRAIN] of int: delay;
int: timelimit;

array[ROW,COL] of TERRAIN: terrain;
array[ROW,COL] of int: soldier;
array[ROW,COL] of bool: Jin;

int: start_row;
int: start_col;

int: maxstep;
set of int: STEP = 1..maxstep;
set of int: STEP0 = 0..maxstep;

% --- GRADER INPUT ---
int: steps;
array[ROW,COL] of int: visit;
int: time;
int: _objective;

% --- SUCCESS MESSAGE ---
output["SUCCESS: Your model contains all variables required by the grader!"];