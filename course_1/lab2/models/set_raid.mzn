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

var set of WARRIOR: raid;

constraint not (dummy in raid);
constraint card(raid) >= l /\ card(raid) <= u;
var int: feuds = sum(p1, p2 in raid where p1 < p2)(hates[clan[p1], clan[p2]]);
constraint feuds <= m;

var int: obj = sum(p in raid)(strength[p]);
solve maximize obj;

output [ "\(obj) \(feuds) <= \(m) \(raid)" ]