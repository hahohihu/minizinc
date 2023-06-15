int: start;

array[int] of var int: readings;
int: N = length(readings);
array[0..N] of var int: temp;

constraint temp[0] = start;
constraint forall(i in 1..N)(
  temp[i] = (temp[i-1] + readings[i]) div 2
);

