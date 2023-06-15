% Parameters
int: start;
array[int] of var int: readings;
int: N = length(readings);

% Action
enum Action = { heat, strongly_heat, cool, strongly_cool, do_nothing };
array[Action] of int: action_cost = [ 1, 5, 3, 9, 0 ];
array[Action] of int: action_temp = [ 1, 4, -2, -5, 0 ];

% Decisions
array[1..N] of var Action: choice;
array[0..N] of var 25..30: temp;
constraint temp[0] = start;

constraint forall(i in 1..N)(
  temp[i] = ((temp[i-1] + readings[i]) div 2) + action_temp[choice[i]]
);

var int: cost;
constraint cost = sum(c in choice)(action_cost[c]);
solve minimize cost;
