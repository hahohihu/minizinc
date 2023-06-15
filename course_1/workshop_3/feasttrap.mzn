% Beauty Trap
% Create the most magnificient feast 
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};
%int: ndish;
%set of int: DISH = 1..ndish;
%set of int: TASTE = 1..6;
%int: spicy = 1; int: sour = 2; int: salty = 3; int: sweet = 4; int: umame = 5; int: bland = 6;
%set of int: TEMP = 1..3;
%int: hot = 1; int: cold = 2; int: warm = 3;


array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;

array[COURSE] of var DISH: dish;

include "alldifferent.mzn";
constraint alldifferent(dish);

include "regular.mzn";
constraint regular([taste[dish[i]] | i in COURSE], 7, 6, dfa, 1, {5});
array[1..7,TASTE] of 0..7: dfa =
[|0,0,4,0,0,0
 |0,0,0,5,0,7
 |0,0,0,0,6,7
 |2,3,0,5,6,7
 |0,3,4,0,0,7
 |2,3,4,5,0,7
 |2,3,4,5,6,0|];

constraint forall(i in 1..len-1)(trace_exp(i) != 5410 /\ temp[dish[i+1]] = cold -> temp[dish[i]] in {cold, warm});
constraint forall(i in 1..len-2)(trace_exp(i) != 5410 /\ heavy[dish[i]] /\ heavy[dish[i+1]] -> not heavy[dish[i+2]]);

var int: obj = sum(d in dish)(value[d]) +
   sum(i in 1..len-1)(
     (temp[dish[i]] != temp[dish[i+1]]) +
     (heavy[dish[i]] != heavy[dish[i+1]])
   ) + len - 1; % len - 1 is guaranteed since taste needs to change between every course
  
solve maximize obj;

output [ "\(len) \(obj) \(dish)" ]