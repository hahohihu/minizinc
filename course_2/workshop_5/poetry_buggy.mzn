% poetry
% place k stanzas of E type and l stanzas of S type and m stanzas of O type
% in order such that
%    no two stanzas of E or S are adjacent
% maximize the sum of differences in effectivenesss of 
% adjacent stanzas of types E and S
int: k;
int: l;
int: m;
set of int: ESSTANZA = 1..k+l;
int: other = 0;
set of int: STANZA = 0..k+l;  % other stanzas are not important

enum KIND = { E, S, O };
array[ESSTANZA] of KIND: kind = [ E | i in 1..k ] ++ [ S | i in 1..l ];

array[ESSTANZA] of int: effect;

int: n = k+l+m;
set of int: POSN = 1..n;
set of int: MAYBEPOSN = 0..n;

array[ESSTANZA] of var MAYBEPOSN: place; % place of each E and S stanza
array[POSN] of var STANZA: what;     % what is in each posn, 0 = other stanza

% symmetry breaking: This constraint is guaranteed to be correct
% Make sure an E or S stanza is in the first position, 
% If there are two other stanzas in a row this has to happen at the end. 
constraint what[1] != other /\ 
           forall(i in 1..n-1)
                 (what[i] = other /\ what[i+1] = other 
                  -> forall(j in i..n)(what[j] = other));

output ["obj = \(obj);\nwhat = \(what);\nplace = \(place);\n"];% poetry

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALL MODELLING ERRORS ARE BELOW THIS LINE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var POSN: len;
var set of int: REALPOSN = 1..len;
constraint forall(i in len+1..n)(what[i] = 0);

constraint forall(i in ESSTANZA, j in REALPOSN)(place[i] = j <-> (what[j] = i \/ what[j] = 0));

include "alldifferent.mzn";
constraint alldifferent_except_0(what);

constraint forall(p1, p2 in ESSTANZA where p1 < p2 /\ place[p1] != 0 /\ place[p2] != 0)
                 (kind[p1] = kind[p2] -> abs(place[p1] - place[p2]) > 1);

var int: obj = sum(p in 1..n-1 where what[p] != 0 /\ what[p+1] != 0)(abs(effect[what[p]] - effect[what[p+1]]));

solve maximize obj;
