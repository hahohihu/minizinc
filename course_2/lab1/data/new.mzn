% Liu Bei forsees that Yuan Shiu will be defeated by Cao Cao
% He needs to find a route to safety in Jin province before the defeat
% But Cao Cao's soldiers are everywhere

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

var STEP: steps;
var set of int: REALSTEP = 1..steps;
var set of int: FAKESTEP = steps+1..maxstep;
array[ROW,COL] of var STEP0: visit; % which step do we visit position or 0 if not visited
set of int: MAYBEROW = 0..nrow;
array[STEP] of var MAYBEROW: row_at;
set of int: MAYBECOL = 0..ncol;
array[STEP] of var MAYBECOL: col_at;

constraint forall(step in REALSTEP)(visit[row_at[step], col_at[step]] = step);
constraint forall(step in FAKESTEP)(row_at[step] = 0);
constraint forall(step in FAKESTEP)(col_at[step] = 0);

include "alldifferent.mzn";
constraint alldifferent_except_0([visit[row, col] | row in ROW, col in COL]);

% start at start position
constraint row_at[1] = start_row;
constraint col_at[1] = start_col;

% reach Jin province
constraint Jin[row_at[steps], col_at[steps]];

% only visit one city
constraint sum(step in REALSTEP)(terrain[row_at[step], col_at[step]] = C) <= 1;

% cant enter Mountain
constraint forall(step in REALSTEP)(terrain[row_at[step], col_at[step]] != M);

% visit only one place in every step
constraint alldifferent_except_0([row_at[step] + col_at[step] * nrow | step in STEP]);

% steps form a path
constraint forall(step in 1..steps-1)(abs(col_at[step] - col_at[step + 1]) + abs(row_at[step] - row_at[step + 1]) = 1);

% no shortcuts
constraint forall(s1, s2 in REALSTEP where s1 > s2)(
  abs(row_at[s1] - row_at[s2]) + abs(col_at[s1] - col_at[s2]) = 1 ->
    s1 = s2 + 1);

% not too much delay
constraint time <= timelimit;
var int: time = sum(step in REALSTEP)(delay[terrain[row_at[step], col_at[step]]]);

% minimize the number of soldiers traversed
% ever so slightly minimize the 
var int: obj = sum(step in REALSTEP)(soldier[row_at[step], col_at[step]]);
solve minimize obj;


array[TERRAIN] of string: ter = [".", "#", "^", "C", "~"];

output
      [ " " ++ ter[fix(terrain[r,c])] ++ if c = ncol then "\n" else "" endif
      | r in ROW, c in COL ]
      ++ ["\n"] ++
      [ if soldier[r,c] > 0 then show_int(2,soldier[r,c]) else " ." endif
          ++ if c = ncol then "\n" else "" endif
      | r in ROW, c in COL ]
      ++ ["\n"] ++
      [ if fix(visit[r,c]) > 0 then show_int(2,visit[r,c]) else " ." endif
          ++ if c = ncol then "\n" else "" endif
      | r in ROW, c in COL ]
      ++ [ "\(steps) \(obj) \(time) \(Jin[row_at[steps], col_at[steps]]) \(row_at) \(col_at)" ];
