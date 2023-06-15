% scheduling suitors
enum SUITOR;
SUITOR: LiuBei; % which suitor is LiuBei
int: n; % number of meetings
set of int: MEETING = 1..n;
array[MEETING] of SUITOR: suitor;

enum ROOM = { Red, Gold, Blue };
array[SUITOR,ROOM] of int: mintime;
array[SUITOR,ROOM] of int: maxtime;
constraint forall(s in SUITOR, r in ROOM)
                 (assert(mintime[s,r] >= 1 /\ maxtime[s,r] >= mintime[s,r],
                  "error in mintime/maxtime at [\(s),\(r)]\n"));

array[ROOM,ROOM] of int: move;
constraint forall(r in ROOM)(assert(move[r,r] = 0,"move[\(r),\(r)] != 0\n"));

int: ndays; % number of days
set of int: DAY = 1..ndays;
int: earliest; % time for earliest meeting start
int: latest;  % time for end of latest meeting

int: lessontime; % time for kung fu lesson;
int: minsep;     % minimum time between consecutive kung fu lessons

array[ROOM] of int: usedstart;  % time others use each room each day
array[ROOM] of int: useddur;    % durations of others use

enum STAGE = {A,B,C};
STAGE: stage;

set of int: TIME = 0..24*ndays;

array[MEETING] of var TIME: start;
array[MEETING] of var TIME: dur;    % duration in false schedule
array[MEETING] of var ROOM: room;
set of int: KUNGFU = 1..n;
array[KUNGFU] of var int: kungfu;  % start time for each lesson
   % unused lessons have start times after 24*ndays

% handle moving across rooms
constraint (stage != A) -> forall(m1, m2 in MEETING where start[m1] < start[m2])(
  start[m2] - (start[m1] + dur[m1]) >= move[room[m1], room[m2]]
);

%%%%%% respect earliest and latest; and usedstart and useddur
array[MEETING] of var 0..23: start_hour_of = [start[meeting] mod 24 | meeting in MEETING];
constraint forall(meeting in MEETING)(
  start_hour_of[meeting] >= earliest 
  /\ 
  start_hour_of[meeting] + dur[meeting] <= latest
  /\
  (start_hour_of[meeting] + dur[meeting] <= usedstart[room[meeting]]
   \/
   start_hour_of[meeting] >= (usedstart[room[meeting]] + useddur[room[meeting]])
  )
);

include "globals.mzn";
constraint disjunctive(start, dur);

%%%% above this are likely correct in form, though they may have subtle bugs of course

array[MEETING] of var TIME: realdur;

%%%%%%% respect mintime (and force it on everyone but Liu Bei, the MC!) (and maxtime and realdur-dur relationship)
constraint forall(meeting in MEETING)(
  if suitor[meeting] = LiuBei then
    realdur[meeting] >= mintime[suitor[meeting], room[meeting]]
  else
    realdur[meeting] = mintime[suitor[meeting], room[meeting]]
  endif
  /\
  dur[meeting] <= maxtime[suitor[meeting], room[meeting]]
  /\
  dur[meeting] >= realdur[meeting]
);

var int: liu_bei_scoring = sum(meeting in MEETING where suitor[meeting] = LiuBei)(realdur[meeting]);

% kungfu
constraint forall(kf in 1..kf_end - 1)(
  kungfu[kf + 1] - (kungfu[kf] + lessontime) >= minsep
);
constraint increasing(kungfu);
var 0..n: kf_end;
int: FAKE_KF = 24 * ndays + 1;
constraint forall(kf in kf_end + 1..n)(kungfu[kf] = FAKE_KF);
constraint (stage != C) -> (kf_end = 0);

array[KUNGFU] of var 0..n: kf_meeting; % make this opt so we can make an inverse and see if one of liu bei's meetings is a kungfu meeting
constraint forall(kf in 1..kf_end)(
  dur[kf_meeting[kf]] = realdur[kf_meeting[kf]] + lessontime % this implicitly gives us an appropriate maxtime upper bound
  /\
  kungfu[kf] = start[kf_meeting[kf]] + realdur[kf_meeting[kf]]
);
constraint forall(kf in kf_end + 1..n)(kf_meeting[kf] = 0);

var int: obj = kf_end * 100 + liu_bei_scoring;
solve maximize obj;

output [
  "start hour of: "
  ++ show(start_hour_of)
  ++ "\nstart: "
  ++ show(start)
  ++ "\ndur: "
  ++ show(dur)
  ++ "\nrealdur: "
  ++ show(realdur)
  ++ "\nroom: "
  ++ show(room)
  ++ "\nkungfu: "
  ++ show(kungfu)
  ++ "\nobj: "
  ++ show(obj)
];

% optimization ideas: symmetry breaking duplicates (esp important for liu bei)
% separate by room to allow more compile-time work
% symmetry breaking Liu Bei - the only expensive one
constraint forall(s in SUITOR)(
  increasing([start[meeting] | meeting in MEETING where suitor[meeting] = s])
);
