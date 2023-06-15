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

constraint taste[dish[1]] = salty;
constraint taste[dish[len]] = sweet;
constraint forall(i in 1..len-1)(
  (taste[dish[i]] != taste[dish[i+1]])
  /\ (taste[dish[i]] = spicy -> taste[dish[i+1]] in {sweet, bland})
  /\ (taste[dish[i]] = sour -> taste[dish[i+1]] in {bland, umame})
  /\ (taste[dish[i]] = sweet -> taste[dish[i+1]] in {salty, sour, bland})
  /\ (temp[dish[i+1]] = cold -> temp[dish[i]] in {cold, warm})
);
constraint forall(i in 1..len-2)(
  heavy[dish[i]] /\ heavy[dish[i+1]] -> not heavy[dish[i+2]]
);

var int: obj = sum(d in dish)(value[d]) +
   sum(i in 1..len-1)(
     (temp[dish[i]] != temp[dish[i+1]]) +
     (heavy[dish[i]] != heavy[dish[i+1]])
   ) + len - 1; % len - 1 is guaranteed since taste needs to change between every course
  
solve maximize obj;

output [ "\(len) \(obj) \(dish)" ]