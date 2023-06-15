include "globals.mzn";

int: length; % length of Huang Gai's back
set of int: LENGTH = 1..length;
int: width; % width of Huang Gai's back
set of int: WIDTH = 1..width;

array[LENGTH,WIDTH] of bool: wound; % wound positions
int: total_wounds = sum(array1d(wound));

int: ntypes;  % number of types of plaster
set of int: TYPE = 1..ntypes;
array[TYPE] of int: number;          % number of plaster available
array[TYPE,1..2] of int: dim;        % dimensions of plaster
int: maxdim = max(array1d(dim));
array[TYPE] of int: price;

set of int: DIMENSION = 0..maxdim;

int: total = sum(number);
set of int: PLASTER = 1..total;
array[TYPE] of int: psum = [ sum(i in 1..t-1)(number[i]) | t in TYPE ];
array[PLASTER] of TYPE: t = [max(t in TYPE)(t*(p > psum[t])) | p in PLASTER];
array[PLASTER] of var LENGTH:  x;
array[PLASTER] of var WIDTH:   y;
enum USAGE = { Long, Wide, Not };
array[PLASTER] of var USAGE:   u;

array[USAGE, 1..2] of 0..2: index = [|1, 2 | 2, 1 | 0, 0|];
array[TYPE, 0..2] of int: dim_ext = array2d(TYPE, 0..2, [[0, dim[t, 1], dim[t, 2]][i] | t in TYPE, i in 1..3]);
array[PLASTER] of var DIMENSION: dx = [dim_ext[t[p], index[u[p], 1]] | p in PLASTER];
array[PLASTER] of var DIMENSION: dy = [dim_ext[t[p], index[u[p], 2]] | p in PLASTER];

constraint diffn(x, y, dx, dy);

constraint forall(p in PLASTER)(x[p] + dx[p] - 1 <= length /\ y[p] + dy[p] - 1 <= width);

constraint forall(l in LENGTH, w in WIDTH where wound[l, w])(
exists(p in PLASTER)(
  u[p] != Not 
  /\ x[p] <= l 
  /\ y[p] <= w 
  /\ x[p] + dx[p] > l 
  /\ y[p] + dy[p] > w
));

var int: cost = sum(p in PLASTER where u[p] != Not)(price[t[p]]);

solve minimize cost;

% constraint x = [1,1,3,1,8,1,1,1,4,1,1,1];
% constraint y = [1,1,4,1,5,1,1,1,1,1,1,1];
% constraint u = [Not, Not, Wide, Not, Long, Not, Not, Not, Long, Not, Not, Not];
output [
  show2d(dim_ext) ++ "\ndx: "
  ++ show(dx) ++ "\ndy: " 
  ++ show(dy) ++ "\nx: "
  ++ show(x) ++ "\ny: "
  ++ show(y) ++ "\nuse"
  ++ show(u) ++ "\ncost:"
  ++ show(cost)
];

% optimizations
constraint forall(p in PLASTER where u[p] = Not)(x[p] = 1 /\ y[p] = 1);
constraint forall(p in 1..total-1 where t[p] = t[p+1])(
  lex_lesseq([u[p], x[p], y[p]], [u[p+1], x[p+1], y[p+1]])
);
