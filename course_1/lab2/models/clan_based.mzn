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
constraint _raid[l] != dummy; % this implies the same is true of all prior because of ordering

array[CLAN] of var int: how_many;
constraint forall(c in CLAN)(how_many[c] = sum(p in _raid where clan[p] = c)(1));

var int: feuds = sum(c in CLAN)(
  sum(c2 in CLAN where c < c2)(
    if hates[c, c2] = 1 \/ hates[c2, c] = 1   
    then how_many[c] * how_many[c2] 
    else 0
    endif
  )
);
constraint feuds <= m;

var int: obj = sum(p in _raid)(strength[p]);
solve maximize obj;

set of WARRIOR: raid :: output_only = { fix(_raid[i]) | i in 1..u } diff { dummy } ;

output [ "\(obj) \(feuds) \(how_many) \(raid)" ]