// The invocation `sum(v, i, a)` yields the sum
// of the elements of the vector `v`,
// starting from the index `i` and the accumulator value `a`.
function sum(v, i = 0, a = 0) =
  i < len(v) ? sum(v, 1 + i, a + v[i]) : a;

// The invocation `cumsum(v, i, a)` yields a vector
// of the cumulative partial sums of the elements of the vector `v`,
// starting from the index `i` and the accumulator value `a`.
function cumsum(v, i = 0, a = 0) =
  i < len(v) ? concat([a], cumsum(v, 1 + i, a + v[i])) : a;
