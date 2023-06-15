include "globals.mzn";

enum PERSON; % set of people to be visited

array[PERSON] of int: duration;    % duration of visit
array[PERSON] of bool: on_weekend; % can the person be visited over weekends
array[PERSON] of int: rank;        % rank of person

array[int,1..2] of PERSON: prec;   % precedences between visits
set of int: PREC = index_set_1of2(prec); 

0..6: starting_day; % which day of the week is day 0 in the schedule
                    % 0 Monday, 1 Tuesday, ..., 5 Saturday, 6 Sunday

% upper bound on the amount of time needed: total duration plus 1 week
% per person who cant be visited on the weekend
int: total = sum(duration) + 7*sum(p in PERSON)(on_weekend[p] = false);
set of int: TIME = 0..total;

array[PERSON] of var TIME: start;
var TIME: end = max(p in PERSON)(start[p] + duration[p]);

% -----------------------------------------------
% non-overlapping
constraint disjunctive(start, duration);

% precedence requirements
% function var TIME: end_time(PERSON: p) = start[p] + duration[p];
constraint forall(i in PREC)(start[prec[i, 1]] + duration[prec[i, 1]] <= start[prec[i, 2]]);

% weekend
constraint forall(p in PERSON where not on_weekend[p])(
  let { var 0..6: day_of_week = (start[p] + starting_day) mod 7 } in
    day_of_week < 5 /\ day_of_week + duration[p] <= 5
);
% rank check
var int: rank_violation = sum(p1, p2 in PERSON where rank[p1] > rank[p2])(start[p2] > start[p1]); % slightly inefficient, could use a sort, but not that much better

solve minimize end * card(PERSON) + rank_violation;
