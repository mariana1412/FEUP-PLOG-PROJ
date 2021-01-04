:- use_module(library(random)).
:- use_module(library(lists)).
:- use_module(library(clpfd)).

%correspondence between the numbers generated and the operators
operation(0, +).
operation(1, *).
operation(2, -).
operation(3, /).

%generates all lists of operators for a star of Points points, using the Params list in labeling
generateAllOps(Points, Params):-
    generateOps(Points, _, Params),
    fail.
generateAllOps(_, _).

%generates a list of Operators for a star of Points points, using the labeling options that produced the fastest processing
generateOps(Points, OpsSymbols):-
    Points>2,
    Points<7,
    L is Points*2,
    length(Ops, L),
    domain(Ops, 0, 3),
    labeling([leftmost, step, up], Ops),
    opsConvert(Ops, OpsSymbols).

%generates a list of Operators for a star of Points points, using the Params labeling options
generateOps(Points, OpsSymbols, Params):-
    Points>2,
    Points<7,
    L is Points*2,
    length(Ops, L),
    domain(Ops, 0, 3),
    labeling(Params, Ops),
    opsConvert(Ops, OpsSymbols).

%generates a random list of Operators for a star of Points points
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

%converts a list of Operator numbers in a list of their respective symbols
opsConvert([], []).
opsConvert([HCode | TCodes], [HSymbol | TSymbols]):-
    operation(HCode, HSymbol),
    opsConvert(TCodes, TSymbols).

%generates and solves all possible stars with Points points, using the fastest labeling options for both operator and number restrictions 
solveAll(Points, OneSolution):-
    Points>2,
    Points<7,
    generateOps(Points, Ops),
    solveStar(Points, Ops, OneSolution),
    fail.
solveAll(Points, _):-
    Points>2,
    Points<7.

%generates and solves all possible stars with Points points, using Params as the labeling options for numbers
solveAll(Points, OneSolution, Params):-
    Points>2,
    Points<7,
    generateOps(Points, Ops),
    solveStar(Points, Ops, OneSolution, Params),
    fail.
solveAll(Points, _, _):-
    Points>2,
    Points<7.

%generates a random star of Points points until one solution is found
findSolution(Points):-
    Points>2,
    Points<7,
    repeat,
    generateRandomOps(Points, Ops),
    solveStar(Points, Ops, 1).

%applies each side of the equations' restriction
restriction(Op1, W, X, Op2, Y, Z):-
    restriction(Op1, W, X, Value),
    restriction(Op2, Y, Z, Value).

%applies addition restriction
restriction(+, X, Y, R):-
    X + Y #= R.

%applies subtraction restriction 
restriction(-, X, Y, R):-
    X - Y #= R.

%applies multiplication restriction. In this puzzle, 0s are not compatible in multiplication, because of its zero property
restriction(*, X, Y, R):-
    X #\= 0,
    Y #\= 0,
    X * Y #= R.

%applies division restriction. It turns the division into a multiplication, since we are dealing with whole numbers. In this puzzle, 0s are not compatible in division
restriction(/, X, Y, R):-
    X #\= 0,
    Y #\= 0,
    R * Y #= X.

%solves a 3 pointed star with Ops operators, using the fastest labeling options
%OneSolution determines if finding one solution will suffice, or if every solution has to be found.
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

%solves a 3 pointed star with Ops operators, using the Params as labeling options
%OneSolution determines if finding one solution will suffice, or if every solution has to be found.
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

%solves a 4 pointed star with Ops operators, using the fastest labeling options
%OneSolution determines if finding one solution will suffice, or if every solution has to be found.
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

%solves a 4 pointed star with Ops operators, using the Params as labeling options
%OneSolution determines if finding one solution will suffice, or if every solution has to be found.
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

%solves a 5 pointed star with Ops operators, using the fastest labeling options
%OneSolution determines if finding one solution will suffice, or if every solution has to be found.
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
    nl, print_solution(Vars, Ops),
    print5(Vars, Ops), nl,
    ((OneSolution == 1, !);(OneSolution == 0)).

%solves a 5 pointed star with Ops operators, using the Params as labeling options
%OneSolution determines if finding one solution will suffice, or if every solution has to be found.
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

%solves a 6 pointed star with Ops operators, using the fastest labeling options
%OneSolution determines if finding one solution will suffice, or if every solution has to be found.
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

%solves a 6 pointed star with Ops operators, using the Params as labeling options
%OneSolution determines if finding one solution will suffice, or if every solution has to be found.
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

%prints a list of operators and a corresponding solution, also in a list
print_solution(Vars, Ops):-
    print(Ops),
    print(Vars), nl.

%prints the solutions for a 5 pointed star, in a star disposition
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

%generates a list to be used as labeling options
generateSearch(Params):-
    search1(X),
    search2(Y),
    search3(Z),
    Params = [X, Y, Z].

%labeling options
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

%generates all possible lists of operators for a 5 pointed star, using all possible labeling options
testSearchOps:-
    generateSearch(Params),
    statistics(runtime, [TI | _]),
    generateAllOps(5, Params),
    statistics(runtime, [TF | _]),
    T is TF - TI,
    format('~w took ~3d seconds', [Params, T]), nl,
    fail.
testSearchOps.

%generates all possible lists of operators that have are solvable for a Points pointed star, using all possible labeling options
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

%generates the path to the log file correspondent to the labeling options combination, for the finding all possible 5 pointed stars and one of their solutions test
getFileHeuristicsStar([S1, S2, S3], Path):-
    atom_concat('docs/logs/', S1, P1),
    atom_concat(P1, '/', P2),
    atom_concat(P2, S2, P3),
    atom_concat(P3, '/', P4),
    atom_concat(P4, S3, P5),
    atom_concat(P5, '/5points.txt', Path).


%generates the path to the log file correspondent to the labeling options combination, for the generating all possible 5 pointed stars test
getFileHeuristicsOps([S1, S2, S3], Path):-
    atom_concat('docs/logs/', S1, P1),
    atom_concat(P1, '/', P2),
    atom_concat(P2, S2, P3),
    atom_concat(P3, '/', P4),
    atom_concat(P4, S3, P5),
    atom_concat(P5, '/ops.txt', Path).

%generates the path to the log file correspondent to all possible Points pointed stars that are solvable and all their solutions
getFilePoints(Points, 0, Path):-
    number_chars(Points, PArray),
    atom_chars(P0, PArray),
    atom_concat('docs/logs/', P0, P1),
    atom_concat(P1, '_points/all.txt', Path).

%generates the path to the log file correspondent to all possible Points pointed stars that are solvable and one of their solutions
getFilePoints(Points, 1, Path):-
    number_chars(Points, PArray),
    atom_chars(P0, PArray),
    atom_concat('docs/logs/', P0, P1),
    atom_concat(P1, '_points/one.txt', Path).

%saves the finding all possible 5 pointed stars and one of their solutions test results in the logs
saveLogsHeuristicsStar:-
    generateSearch(Params),

    getFileHeuristicsStar(Params, 1, Path),
    open(Path, write, S),
    current_output(Console),
    set_output(S),
    

    statistics(walltime, _),
    solveAll(5, 1, Params),
    statistics(walltime, [_|T]),
    format('~w took ~3d seconds', [Params, T]),

    close(S),
    set_output(Console),
    format('~w took ~3d seconds', [Params, T]), nl,

    fail.
saveLogsHeuristicsStar.

%saves the generating all possible 5 pointed stars test results in the logs
saveLogsOps:-
    generateSearch(Params),

    getFileHeuristicsOps(Params, Path),
    open(Path, write, S),
    current_output(Console),
    set_output(S),
    

    statistics(walltime, _),
    generateAllOps(5, Params),
    statistics(walltime, [_|T]),
    format('~w took ~3d seconds', [Params, T]),

    close(S),
    set_output(Console),
    format('~w took ~3d seconds', [Params, T]), nl,

    fail.
saveLogsOps.

points(3).
points(4).
points(5).
points(6).

%finds all possible Points pointed stars that are solvable and all their solutions and saves the results in their logs.
%repeats, but only finding one solution for each solvable star
saveLogsPoints:-
    points(Points),

    getFilePoints(Points, 0, Path),
    open(Path, write, S),
    current_output(Console),
    set_output(S),
    
    statistics(walltime, _),
    solveAll(Points, 0),
    statistics(walltime, [_|T]),
    format('~d Points, all solutions took ~3d seconds', [Points, T]),

    close(S),
    set_output(Console),
    format('~d Points, all solutions took ~3d seconds', [Points, T]), nl,

    getFilePoints(Points, 1, Path1),
    open(Path1, write, S1),
    current_output(Console),
    set_output(S1),

    statistics(walltime, _),
    solveAll(Points, 1),
    statistics(walltime, [_|T1]),
    format('~d Points, one solution took ~3d seconds', [Points, T1]),

    close(S1),
    set_output(Console),
    format('~d Points, one solution took ~3d seconds', [Points, T1]), nl,
    fail.
saveLogsPoints.