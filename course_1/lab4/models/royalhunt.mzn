int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;

array[COURT,HORSE] of int: enjoy;

set of int: NULLHORSE = 0..m;
set of int: NULLCOURT = 0..n;
array[COURT] of var NULLHORSE: horse; % these include 0 for no assignment
array[HORSE] of var NULLCOURT: court;

int: pairlen = min(n, m);
set of int: PAIRS = 1..pairlen;
array[PAIRS] of var COURT: mounted_court;
array[PAIRS] of var HORSE: mounted_horse;
constraint forall(c in COURT where horse[c] != 0)(c in mounted_court);
constraint forall(h in HORSE where court[h] != 0)(h in mounted_horse);
constraint forall(i in PAIRS)(horse[mounted_court[i]] = mounted_horse[i]);
constraint forall(i in PAIRS)(court[mounted_horse[i]] = mounted_court[i]);
constraint forall(i in 1..pairlen-1)(mounted_court[i] < mounted_court[i+1]);
include "alldifferent.mzn";
constraint alldifferent(mounted_horse);

constraint forall(c in mounted_court where c != emperor)(enjoy[emperor, horse[emperor]] > enjoy[c, horse[c]]);

constraint forall(peon in mounted_court)(
  forall(lord in COURT where rank[lord] > rank[peon])(
    horse[lord] != 0 /\ beauty[horse[lord]] >= beauty[horse[peon]]
  )
);

var int: penalty = sum(hare in mounted_horse)(
  sum(turtle in HORSE where speed[hare] > speed[turtle])(
    court[turtle] = 0 
    \/ ability[court[hare]] < ability[court[turtle]]
  )
);

constraint forall(c in mounted_court)(enjoy[c, horse[c]] >= 0);
var int: obj = sum([enjoy[c, horse[c]] | c in mounted_court]) - 100 * penalty;

solve maximize obj;

% output [ "\(mounted_court) \(mounted_horse)" ]
output [ "rank=\(rank)\(sorted_rank)\(sorted_court)\npenalty=\(penalty)\nm=\(m)\nn=\(n)\nhorse=\(horse)\(mounted_horse)\ncourt=\(court)\(mounted_court)\nobj=\(obj)\n" ]