include "globals.mzn";

int: length; % height of lake
set of int: LENGTH = 0..length-1;
int: width; % width of lake
set of int: WIDTH = 0..width-1;
set of int: COORD = 0..max(length-1, width-1);

int: ntypes;  % number of types of ship
set of int: TYPE = 1..ntypes;
array[TYPE] of int: number;         % number of each type of ship
array[TYPE] of set of SHAPE: config; % configs for each type of ship

int: nshapes; % number of shapes
set of int: SHAPE = 1..nshapes;
set of int: SHAPE0 = 0..nshapes;
array[SHAPE] of set of ROFF: shape;

int: nroff; % number of rectangle offsets
set of int: ROFF = 1..nroff;
set of int: ROFF0 = 0..nroff;
array[ROFF,1..4] of int: rectoff; % x offset, y offset, width, height

int: total_ships = sum(number);
set of int: SHIP = 1..total_ships;

%% vanilla input ^

array[SHIP] of TYPE: ship_type = [ty | ty in TYPE, _ in 1..number[ty]];
array[SHIP] of var LENGTH:  x;
array[SHIP] of var WIDTH:   y;
array[SHIP] of var SHAPE0:  k;

array[LENGTH] of WIDTH: mist; % mist starts at this width, goes downward
array[WIDTH] of int: arrow;  % number of arrows that arrive at this height
array[TYPE] of int: price;
int: budget;
enum STAGE = {A,B,C,D,E,F};
STAGE: stage;

int: FILLERSHIP = 1;
set of int: SHAPEX = 1..nshapes + 1;
array[ROFF] of int: dx = col(rectoff, 3);
array[ROFF] of int: dy = col(rectoff, 4);
array[ROFF] of int: xoff = col(rectoff, 1);
array[ROFF] of int: yoff = col(rectoff, 2);
array[ROFF0,1..2] of int:      rect_size = array2d(ROFF0, 1..2, 
  [0, 0] 
  ++ [[dx[roff], dy[roff]][i] | roff in ROFF, i in 1..2]
);
array[ROFF0,1..2] of int:      rect_offset = array2d(ROFF0, 1..2, 
  [0, 0] 
  ++ [[xoff[roff], yoff[roff]][i] | roff in ROFF, i in 1..2]
);
array[SHAPEX] of set of ROFF0: _shape = [{0}] ++ shape;
array[SHIP,1..2] of var COORD:   coordinates = array2d(SHIP, 1..2, [[x[s], y[s]][i] | s in SHIP, i in 1..2]);
array[SHIP] of var SHAPEX:     k_extra    = [s + 1 | s in k]; % geost requires index-set of _shape to be 1..a, so SHAPE0 won't work


constraint geost_bb(
  2, 
  rect_size, 
  rect_offset, 
  _shape,    
  coordinates,
  k_extra,
  [0, 0],
  [length, width]
);

constraint stage < F -> forall(ship in SHIP)(k[ship] in config[ship_type[ship]]);
constraint stage = F -> forall(ship in SHIP)(k[ship] in config[ship_type[ship]] union {0});

array [LENGTH, WIDTH] of var bool: bitmap;
constraint forall(w in WIDTH, l in LENGTH)(
  bitmap[l, w] = exists(ship in SHIP)(
    let { var set of ROFF: shp = shape[k[ship]]
      } 
    in exists(roff in shp)(
      let { var LENGTH: rx = x[ship] + xoff[roff],
            var WIDTH: ry = y[ship] + yoff[roff] } in
      l >= rx
      /\
      l < rx + dx[roff]
      /\
      w >= ry
      /\
      w < ry + dy[roff]
    )
  )
);

constraint stage >= C -> (
  forall(l in LENGTH)(
    forall(w in 0..mist[l] - 1)(bitmap[l, w] = false)
  )
);

constraint stage >= D -> arrows = sum(w in WIDTH)(sum(l in LENGTH)(bitmap[l, w]) * arrow[w]);
var int: arrows;
constraint stage <= C -> arrows = 0;

constraint stage = F -> (
  sum(ship in SHIP where k[ship] != 0)(price[ship_type[ship]]) <= budget
);

solve maximize arrows;

output [
  show2d(rect_size) ++ "\n"
  ++ show2d(rect_offset) ++ "\n"
  ++ "\ndx:\n"
  ++ show(dx)
  ++ "\ndy:\n"
  ++ show(dy)
  ++ "\nxoff:\n"
  ++ show(xoff)
  ++ "\nyoff:\n"
  ++ show(yoff)
  ++ "\nshape:\n"
  ++ show(shape)
  ++ "\nx:\n"
  ++ show(x)
  ++ "\ny:\n"
  ++ show(y)
  ++ "\nk:\n"
  ++ show(k)
  ++ "\nk_extra:\n"
  ++ show(k_extra)
  ++ "\nshape_extra:\n"
  ++ show(_shape)
  ++ "\nship_type:\n"
  ++ show(ship_type)
  ++ "\nbitmap:\n"
  ++ show2d(bitmap)
  ++ "\narrows:\n"
  ++ show(arrows)
];


% symmetry breaking
constraint forall(s in 1..total_ships - 1 where ship_type[s] = ship_type[s + 1])(lex_lesseq([k[s], x[s], y[s]], [k[s+1], x[s+1], y[s+1]]));


