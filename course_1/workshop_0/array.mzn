int: n;

array[1..n] of var 0..9: x;

constraint sum(x) == product(x);
constraint forall(i in 2..n)(
  x[i-1] <= x[i]
);