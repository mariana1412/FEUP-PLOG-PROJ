operation(0, '+').
operation(1, '-').
operation(2, '*').
operation(3, '/').

%1st example at https://erich-friedman.github.io/puzzle/star/
%each sublist contains both operations of a corner, starting with the top corner and proceeding clockwise
example([
    [1, 2], %top corner
    [2, 1], %right corner
    [2, 2], %bottom right corner
    [0, 0], %bottom left corner
    [2, 0]  %left corner
    ]).