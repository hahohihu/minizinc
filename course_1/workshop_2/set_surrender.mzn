% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

var set of NEGOTIATOR: party;

constraint card(party) >= l /\ card(party) <= u;
var int: total_str = sum(p1, p2 in party where p1 < p2)(joint[p1, p2]);
constraint total_str >= m;

var int: obj = min(n in party)(honor[n]);
solve maximize obj;

output [ "\(obj) \(obj) \(total_str) \(party)" ];
