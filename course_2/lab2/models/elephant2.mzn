include "globals.mzn";
int: T; % maximum time allowed;
set of int: TIME = 1..T;
set of int: STIME = 0..T;
var TIME: end;
var set of int: REALTIME = 1..end;
var set of int: FAKETIME = (end + 1)..T;

int: E; % weight of elephant in STONES;
set of int: STONE = 0..E;

int: G; % number of guards
set of int: GUARD = 1..G;
array[GUARD] of STONE: easy;
array[GUARD] of STONE: hard;
array[GUARD] of TIME: tired;


% -------------------------------------------
set of int: ACT = -1..E; % -1 = goto bank, 0 = wait, > 0 carry stones
int: wait = 0;
int: to_bank = -1;

array[GUARD, DACT] of ACT: dact2act = array2d(GUARD, DACT, [[-1, 0, easy[guard], hard[guard]][i] | guard in GUARD, i in 1..4]);
array[GUARD, TIME] of ACT: act :: output_only =
  array2d(GUARD, TIME, [dact2act[guard, fix(dact[guard, time])] | guard in GUARD, time in TIME]);
  
enum DACT = {GOTO_BANK, WAIT, EZ ,HD};
array[GUARD, TIME] of var DACT: dact;
  % FAKETIME
  constraint forall(time in FAKETIME, guard in GUARD)(dact[guard, time] = WAIT);
  % only one direction at a time
  constraint forall(time in REALTIME)(TOBANK[time] * TOBOAT[time] = 0);
  
constraint sum(guard in GUARD, time in TIME where dact[guard, time] >= EZ)(dact2act[guard, dact[guard, time]]) >= E;

constraint forall(time in REALTIME, guard in GUARD)(dact[guard, time] = HD -> forall(t2 in time + 1..min(time + tired[guard], end))(dact[guard, t2] <= WAIT));

array[1..2, DACT] of int: t =
  [|0, 1, 2, 2  
   |1, 2, 0, 0
   |];
constraint forall(guard in GUARD)(
  regular(row(dact, guard), 2, DACT, t, 1, {1,2})
);

array[TIME] of var 0..G: WAITING;
  constraint forall(time in REALTIME)(WAITING[time] = count(col(dact, time), WAIT));
array[TIME] of var 0..b: TOBANK;
  constraint forall(time in REALTIME)(TOBANK[time] = count(col(dact, time), GOTO_BANK));
array[TIME] of var 0..b: TOBOAT;
  constraint forall(time in REALTIME)(TOBOAT[time] = G - WAITING[time] - TOBANK[time]);
% idea use a set here to save on iterations (especially in the nested foralls above)

GUARD: b; % maximum people on boat;
  array[STIME] of var 0..b: ONBOAT;
  constraint ONBOAT[0] = 0;
  constraint forall(time in REALTIME)(ONBOAT[time] = ONBOAT[time - 1] + TOBOAT[time] - TOBANK[time]);

GUARD: p; % maximum people on pier;
  constraint forall(time in REALTIME)(TOBANK[time] <= p);
  constraint forall(time in REALTIME)(TOBOAT[time] <= p);
  
solve minimize end;
