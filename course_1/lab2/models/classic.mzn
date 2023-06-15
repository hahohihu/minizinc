% assignment 2
% select a set of raiding warrior
enum WARRIOR;
WARRIOR: dummy;
enum CLAN; % the clan they belong too

int: l; % minimum raid party size
int: u; % maximum raid party size
int: m; % limit of hatreds

array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;

array[1..u] of var WARRIOR: _raid;

constraint forall(i in 1..u-1)(_raid[i] + (_raid[i] = dummy) > _raid[i+1]);
constraint forall(i in 1..l)(_raid[i] != dummy);
constraint sum(p1, p2 in _raid where p1 < p2)(hates[clan[p1], clan[p2]]) <= m;

var int: obj = sum(p in _raid)(strength[p]);
solve maximize obj;

set of WARRIOR: raid :: output_only = { fix(_raid[i]) | i in 1..u } diff { dummy } ;

output [ "\(obj)" ]
