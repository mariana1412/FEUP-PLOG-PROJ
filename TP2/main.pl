:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(clpfd)).

%2nd example at https://erich-friedman.github.io/puzzle/star/
%operations from top to bottom, left to right (see images/internalRepresentation.png)
example([+, *, *, +, -, *, +, +, +, /]).

operation(0, +).
operation(1, -).
operation(2, *).
operation(3, /).

generateOps(OpsSymbols):-
    length(Ops, 10),
    domain(Ops, 0, 3),
    labeling([], Ops),
    opsConvert(Ops, OpsSymbols).
    
opsConvert([], []).
opsConvert([HCode | TCodes], [HSymbol | TSymbols]):-
    operation(HCode, HSymbol),
    opsConvert(TCodes, TSymbols).

solveAll:-
    generateOps(Ops),
    solve(Ops),
    fail.

restriction(Op1, W, X, Op2, Y, Z):-
    restriction(Op1, W, X, Value),
    restriction(Op2, Y, Z, Value).

restriction(+, X, Y, R):-
    X + Y #= R.

restriction(-, X, Y, R):-
    X - Y #= R.

restriction(*, X, Y, R):-
    X * Y #= R.

restriction(/, X, Y, R):-
    %X / Y #= R
    R * Y #= X.

findSolution:-
    repeat,
    generateOps(Ops),
    solve(Ops).

solve(Ops):-
    Ops = [O0, O1, O2, O3, O4, O5, O6, O7, O8, O9],
    Vars = [A, B, C, D, E, F, G, H, I, J],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    restriction(O2, B, C, O3, D, E),
    restriction(O4, B, F, O9, H, J),
    restriction(O6, I, F, O0, C, A),
    restriction(O8, I, H, O5, G, E),
    restriction(O1, A, D, O7, G, J),
    labeling([], Vars),
    print_solution(Vars, Ops).

print_solution(Vars, Ops):-
    Ops = [O0, O1, O2, O3, O4, O5, O6, O7, O8, O9],
    Vars = [A, B, C, D, E, F, G, H, I, J],
    format('~t~d~t~14|', [A]), nl,
    format('~4|~t~w~t~w~t~10|', [O0, O1]), nl,
    format('~t~d~t~2|~t~w~t~4|~t~d~t~6|~t=~t~8|~t~d~t~10|~t~w~t~12|~t~d~t~14|', [B, O2, C, D, O3, E]), nl,
    format('~t~w~t=~t~6|~8|~t=~t~w~t~14|', [O4, O5]), nl,
    format('~t~d~t~6|~8|~t~d~t~14|', [F, G]), nl,
    format('~4|~t=~t~6|~8|~t=~t~10|', []), nl,
    format('~t~w~t~3|~t~d~t~11|~t~w~t~13|', [O6, H, O7]), nl,
    format('~2|~t~w~t~w~t~12|', [O8, O9]), nl,
    format('~t~d~t~2|~12|~t~d~t~14|', [I, J]), nl.