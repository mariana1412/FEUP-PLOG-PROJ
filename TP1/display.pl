number(6, '1').
number(5, '2').
number(4, '3').
number(3, '4').
number(2, '5').
number(1, '6').

code(0, ' ').
code(1, 'G').
code(2, 'B').
code(3, 'W').

initial([
[[1, 1, 1], [3, 0, 1], [1, 1, 1], [3, 0, 1], [2, 0, 1], [1, 1, 1]],
[[2, 0, 1], [1, 1, 1], [2, 0, 1], [1, 1, 1], [3, 0, 1], [2, 0, 1]],
[[1, 1, 1], [3, 0, 1], [1, 1, 1], [1, 1, 1], [1, 1, 1], [1, 1, 1]],
[[2, 0, 1], [1, 1, 1], [2, 0, 1], [1, 1, 1], [1, 1, 1], [2, 0, 1]],
[[3, 0, 1], [1, 1, 1], [3, 0, 1], [3, 0, 1], [1, 1, 1], [3, 0, 1]],
[[1, 1, 1], [2, 0, 1], [1, 1, 1], [2, 0, 1], [1, 1, 1], [3, 0, 1]]
]).

printNumber(N):- write('|'), number(N, Number), write('  '), write(Number), write('  |').

printPoints(0, _Points):- write('    |').
printPoints(Color, Points):- Color\=0, write('/'), write(Points).

printStack(0, _Stack).
printStack(Color, Stack):- Color\=0, write('/'), write(Stack), write('|').

printCell([Color, Points, Stack]):-
        code(Color, Character),
        write(Character),
        printPoints(Color, Points),
        printStack(Color, Stack).

printLine([]).
printLine([Cell | Line]):- printCell(Cell), printLine(Line).

printSeparator(1):- write('|-----|-----|-----|-----|-----|-----|-----|'), nl, printSeparator(2).
printSeparator(2):- write('|     |     |     |     |     |     |     |'), nl.

printTab([], 0, _Player, _PointsBlack, _PointsWhite):- write('|-----|-----|-----|-----|-----|-----|-----|'), nl.
printTab([Line|B], N, Player, PointsBlack, PointsWhite):- 
        printSeparator(1),
        printNumber(N),
        printLine(Line),
        printInfo(N, Player, PointsBlack, PointsWhite), nl,
        printSeparator(2),
        N1 is N-1, printTab(B, N1, Player, PointsBlack, PointsWhite).

%o tabuleiro vai ser de tamanho NxN
printBoard(X, N, Player, PointsBlack, PointsWhite):- printHeader, printTab(X, N, Player, PointsBlack, PointsWhite).

printHeader:-
    nl,
    printSeparator(1),
    write('|     |  A  |  B  |  C  |  D  |  E  |  F  | '),
    write('Cell Format: Color/Points/StackHeight\n'),
    printSeparator(2).

printInfo(6, 0, _PointsBlack, _PointsWhite):- write(' It is black\'s turn!').
printInfo(6, 1, _PointsBlack, _PointsWhite):- write(' It is white\'s turn!').
printInfo(4, _Player, PointsBlack, _PointsWhite):- write(' Black has '), write(PointsBlack), write(' points.').
printInfo(3, _Player, _PointsBlack, PointsWhite):- write(' White has '), write(PointsWhite), write(' points.').
printInfo(_N, _Player, _PointsBlack, _PointsWhite).


