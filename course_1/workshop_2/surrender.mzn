% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

array[1..u] of var NEGOTIATOR: p;

constraint forall(i in 1..u-1)(p[i] + (p[i] = dummy) > p[i+1]);
constraint forall(i in 1..l)(p[i] != dummy);

var int: total_str = sum(p1, p2 in p where p1 < p2)(joint[p1, p2]);
constraint total_str >= m;

var int: obj = min(n in p where n != dummy)(honor[n]);
solve maximize obj;

set of NEGOTIATOR: party :: output_only = { fix(p[i]) | i in 1..u };
output [ "\(obj) \(obj) \(total_str) \(party)" ];
