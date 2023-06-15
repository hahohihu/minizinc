int: len;
set of int: Index = 1..len;
array[Index] of var 0..3: arr;

constraint arr[1] = 0; 
constraint arr[len] = 3;
constraint forall(i in 1..len-1)(
  arr[i] + arr[i + 1] <= 3
);

constraint forall(i in Index where i mod 3 = 0)
                 (arr[i] >= 2);

solve maximize sum(arr);

output [ "\(sum(arr)) = \(arr)" ]