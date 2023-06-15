int: T; % maximum time allowed;
set of int: TIME = 1..T;
int: G; % number of guards
int: F; 
int: W;
set of int: POSTIME = 0..T;

var TIME: end;                            % end time;
var set of int: REALTIME = 1..end;
var set of int: REALTIME_PAIRS= 1..end-1;
var set of int: FAKETIME = end + 1..T;

enum LOC = { BANK, BOAT };
array[LOC] of LOC: opposite = [ BOAT, BANK ];
% static things - these happen before the given action, 
% e.g. the elephant is on the shore @ 0, then an action happens, then the elephant is somewhere @ 1
array[POSTIME] of var LOC: elephant;
array[POSTIME, LOC] of var 0..F: food;
constraint food[0, BOAT] = 0;
array[POSTIME, LOC] of var 0..W: water;
constraint water[0, BOAT] = 0;

predicate boat_bank_symmetry(array[POSTIME, LOC] of var int: arr, int: UB) = forall(time in POSTIME)(arr[time, BANK] + arr[time, BOAT] = UB);
constraint boat_bank_symmetry(food, F);
constraint boat_bank_symmetry(water, W);

array[TIME] of var bool: elephant_move;
constraint forall(time in REALTIME)(elephant_move[time] = (elephant[time] != elephant[time - 1]));
array[TIME] of var -F..F: move_food;      % move food +ve bank to boat, -ve boat to bank
constraint forall(time in REALTIME)(food[time - 1, BOAT] + move_food[time] = food[time, BOAT]); 
array[TIME] of var -W..W: move_water;     % move water +ve bank to boat, -ve boat to bank
constraint forall(time in REALTIME)(water[time - 1, BOAT] + move_water[time] = water[time, BOAT]);
constraint forall(time in FAKETIME)(move_food[time] = 0 /\ move_water[time] = 0);

% =========================^ all structural above - making sure our arrays mean what they should. Now we get to the actual logic

% elephant starts on the bank
constraint elephant[0] = BANK;
% and ends on the boat
constraint elephant[end - 1] = BOAT;

% guards move with food/water 1:1 in one direction
constraint forall(time in REALTIME)(abs(move_food[time] + move_water[time]) <= G);
constraint forall(time in REALTIME)(move_food[time] * move_water[time] >= 0); % both must have the same sign or 0

% no eating
constraint forall(time in REALTIME)(elephant_move[time] \/ (food[time, elephant[time]] = 0 <-> water[time, elephant[time]] = 0));

constraint forall(time in REALTIME)(elephant_move[time] = (
  let {var LOC: op = opposite[elephant[time - 1]]} in
  food[time, op] = water[time, op] % same amount of food and water
  /\ food[time, elephant[time - 1]] < food[time, op] % and more food 
  /\ water[time, elephant[time - 1]] < water[time, op] % and more water
));

% no food/water at the end
constraint food[end, BOAT] = 0 /\ water[end, BOAT] = 0;

solve minimize end;

% output [];