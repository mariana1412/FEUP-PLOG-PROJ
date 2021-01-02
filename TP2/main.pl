:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(clpfd)).

example(3, [+,-,-,/,-,+]).
example(4, [/,+,-,-,/,/,+,-]).
example(5, [+,+,-,-,*,+,/,+,/,+]).
example(6, [+,/,+,+,+,+,-,-,-,-,-,+]).

operation(0, +).
operation(1, *).
operation(2, -).
operation(3, /).

generateAllOps(Points, Params):-
    generateOps(Points, _, Params),
    fail.
generateAllOps(_, _).

generateOps(Points, OpsSymbols):-
    Points>2,
    Points<7,
    L is Points*2,
    length(Ops, L),
    domain(Ops, 0, 3),
    labeling([], Ops),
    opsConvert(Ops, OpsSymbols).

generateOps(Points, OpsSymbols, Params):-
    Points>2,
    Points<7,
    L is Points*2,
    length(Ops, L),
    domain(Ops, 0, 3),
    labeling(Params, Ops),
    opsConvert(Ops, OpsSymbols).

generateRandomOps(Points, OpsSymbols):-
    Points>2,
    Points<7,
    L is Points*2,
    length(Ops, L),
    createRandom(Ops),
    opsConvert(Ops, OpsSymbols).

createRandom([]).
createRandom([H | T]):-
    random(0, 4, H),
    createRandom(T).
    
opsConvert([], []).
opsConvert([HCode | TCodes], [HSymbol | TSymbols]):-
    operation(HCode, HSymbol),
    opsConvert(TCodes, TSymbols).

solveAll(Points, OneSolution):-
    Points>2,
    Points<7,
    generateOps(Points, Ops),
    solveStar(Points, Ops, OneSolution),
    fail.
solveAll(Points, _):-
    Points>2,
    Points<7.

solveAll(Points, OneSolution, Params):-
    Points>2,
    Points<7,
    generateOps(Points, Ops),
    solveStar(Points, Ops, OneSolution, Params),
    fail.
solveAll(Points, _, _):-
    Points>2,
    Points<7.

findSolution(Points):-
    Points>2,
    Points<7,
    repeat,
    generateRandomOps(Points, Ops),
    solveStar(Points, Ops, 1).

restriction(Op1, W, X, Op2, Y, Z):-
    restriction(Op1, W, X, Value),
    restriction(Op2, Y, Z, Value).

restriction(+, X, Y, R):-
    X + Y #= R.

restriction(-, X, Y, R):-
    X - Y #= R.

restriction(*, X, Y, R):-
    X #\= 0,
    Y #\= 0,
    X * Y #= R.

restriction(/, X, Y, R):-
    X #\= 0,
    Y #\= 0,
    R * Y #= X.

solveStar(3, Ops, OneSolution):-
    Ops = [O0, O1, O2, O3, O4, O5],
    Vars = [A, B, C, D, E, F],
    domain(Vars, 0, 5),
    all_distinct(Vars),
    restriction(O0, A, B, O5, E, F),
    restriction(O2, D, B, O3, C, F),
    restriction(O4, D, E, O1, C, A),
    !, labeling([min, middle, up], Vars),
    print_solution(Vars, Ops),
    ((OneSolution == 1, !);(OneSolution == 0)).

solveStar(3, Ops, OneSolution, Params):-
    Ops = [O0, O1, O2, O3, O4, O5],
    Vars = [A, B, C, D, E, F],
    domain(Vars, 0, 5),
    all_distinct(Vars),
    restriction(O0, A, B, O5, E, F),
    restriction(O2, D, B, O3, C, F),
    restriction(O4, D, E, O1, C, A),
    !, labeling(Params, Vars),
    print_solution(Vars, Ops),
    ((OneSolution == 1, !);(OneSolution == 0)).

solveStar(4, Ops, OneSolution):-
    Ops = [O0, O1, O2, O3, O4, O5, O6, O7],
    Vars = [A, B, C, D, E, F, G, H],
    domain(Vars, 0, 7),
    all_distinct(Vars),
    restriction(O6, H, F, O0, B, A),
    restriction(O1, A, C, O7, G, H),
    restriction(O2, D, B, O3, C, E),
    restriction(O4, D, F, O5, G, E),
    !, labeling([min, middle, up], Vars),
    print_solution(Vars, Ops),
    ((OneSolution == 1, !);(OneSolution == 0)).

solveStar(4, Ops, OneSolution, Params):-
    Ops = [O0, O1, O2, O3, O4, O5, O6, O7],
    Vars = [A, B, C, D, E, F, G, H],
    domain(Vars, 0, 7),
    all_distinct(Vars),
    restriction(O6, H, F, O0, B, A),
    restriction(O1, A, C, O7, G, H),
    restriction(O2, D, B, O3, C, E),
    restriction(O4, D, F, O5, G, E),
    !, labeling(Params, Vars),
    print_solution(Vars, Ops),
    ((OneSolution == 1, !);(OneSolution == 0)).

solveStar(5, Ops, OneSolution):-
    Ops = [O0, O1, O2, O3, O4, O5, O6, O7, O8, O9],
    Vars = [A, B, C, D, E, F, G, H, I, J],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    restriction(O2, B, C, O3, D, E),
    restriction(O4, B, F, O9, H, J),
    restriction(O6, I, F, O0, C, A),
    restriction(O8, I, H, O5, G, E),
    restriction(O1, A, D, O7, G, J),
    !, labeling([min, middle, up], Vars),
    print_solution(Vars, Ops),
    ((OneSolution == 1, !);(OneSolution == 0)).

solveStar(5, Ops, OneSolution, Params):-
    Ops = [O0, O1, O2, O3, O4, O5, O6, O7, O8, O9],
    Vars = [A, B, C, D, E, F, G, H, I, J],
    domain(Vars, 0, 9),
    all_distinct(Vars),
    restriction(O2, B, C, O3, D, E),
    restriction(O4, B, F, O9, H, J),
    restriction(O6, I, F, O0, C, A),
    restriction(O8, I, H, O5, G, E),
    restriction(O1, A, D, O7, G, J),
    !, labeling(Params, Vars),
    print_solution(Vars, Ops),
    ((OneSolution == 1, !);(OneSolution == 0)).

solveStar(6, Ops, OneSolution):-
    Ops = [O0, O1, O2, O3, O4, O5, O6, O7, O8, O9, O10, O11],
    Vars = [A, B, C, D, E, F, G, H, I, J, K, L],
    domain(Vars, 0, 11),
    all_distinct(Vars),
    restriction(O6, H, F, O0, C, A),
    restriction(O1, A, D, O7, G, K),
    restriction(O2, B, C, O3, D, E),
    restriction(O4, B, F, O10, I, L),
    restriction(O11, L, J, O5, G, E),
    restriction(O8, H, I, O9, J, K),
    !, labeling([min, middle, up], Vars),
    print_solution(Vars, Ops),
    ((OneSolution == 1, !);(OneSolution == 0)).

solveStar(6, Ops, OneSolution, Params):-
    Ops = [O0, O1, O2, O3, O4, O5, O6, O7, O8, O9, O10, O11],
    Vars = [A, B, C, D, E, F, G, H, I, J, K, L],
    domain(Vars, 0, 11),
    all_distinct(Vars),
    restriction(O6, H, F, O0, C, A),
    restriction(O1, A, D, O7, G, K),
    restriction(O2, B, C, O3, D, E),
    restriction(O4, B, F, O10, I, L),
    restriction(O11, L, J, O5, G, E),
    restriction(O8, H, I, O9, J, K),
    !, labeling(Params, Vars),
    print_solution(Vars, Ops),
    ((OneSolution == 1, !);(OneSolution == 0)).

print_solution(Vars, Ops):-
    print(Ops),
    print(Vars), nl.

print5(Vars, Ops):-
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

generateSearch(Params):-
    search1(X),
    search2(Y),
    search3(Z),
    Params = [X, Y, Z].

search1(leftmost).
search1(min).
search1(max).
search1(ff).
search1(anti_first_fail).
search1(occurrence).
search1(ffc).
search1(max_regret).
search2(step).
search2(enum).
search2(bisect).
search2(median).
search2(middle).
search3(up).
search3(down).

testSearchOps:-
    generateSearch(Params),
    statistics(runtime, [TI | _]),
    generateAllOps(5, Params),
    statistics(runtime, [TF | _]),
    T is TF - TI,
    format('~w took ~3d seconds', [Params, T]), nl,
    fail.
testSearchOps.

testSearchStars(Points, OneSolution):-
    Points>2,
    Points<7,
    generateSearch(Params),
    statistics(walltime, _),
    solveAll(Points, OneSolution, Params),
    statistics(walltime, [_|T]),
    format('~w took ~3d seconds', [Params, T]), nl,
    fail.
testSearchStars(Points, _):-
    Points>2,
    Points<7.
