% SOLUTION FORMAT CHECKER: DO NOT EDIT!!!

% --- DATA INPUT ---
int: length; % length of river near Cao Cao's camp
set of int: LENGTH = 0..length-1;
int: width; % width of river near Cao Cao's camp
set of int: WIDTH = 0..width-1;

int: ntypes;  % number of types of ship
set of int: TYPE = 1..ntypes;
array[TYPE] of int: number;          % number of each type of ship
array[TYPE] of set of SHAPE: config; % configs for each type of ship

int: nshapes; % number of shapes
set of int: SHAPE = 1..nshapes;
set of int: SHAPE0 = 0..nshapes;     % shape 0 used in stage F
array[SHAPE] of set of ROFF: shape;

int: nroff; % number of rectangle offsets
set of int: ROFF = 1..nroff;
array[ROFF,1..4] of int: rectoff; % x offset, y offset, length, width

int: total_ships = sum(number);
set of int: SHIP = 1..total_ships;

array[LENGTH] of WIDTH: mist; % mist start at each width, goes downward
array[WIDTH] of int: arrow;   % number of arrows (1000's) that arrive this far into river
array[TYPE] of int: price;    % price to bribe boat type
int: budget;                  % total budget for bribes
enum STAGE = {A,B,C,D,E,F};
STAGE: stage;

% --- GRADER INPUT ---
array[SHIP] of LENGTH:  x;
array[SHIP] of WIDTH:   y;
array[SHIP] of SHAPE0:  k;
int: _objective;

% --- SUCCESS MESSAGE ---
output["SUCCESS: Your model contains all variables required by the grader!"];
