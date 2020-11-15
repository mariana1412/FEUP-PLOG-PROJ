%inverts the line number, to print the right coordinate on the left side
number(6, '1').
number(5, '2').
number(4, '3').
number(3, '4').
number(2, '5').
number(1, '6').

%translates the first cell list item
code(0, ' ').
code(1, 'G').
code(2, 'B').
code(3, 'W').

%initial board setup
initial([
[[1, 1, 1], [3, 0, 1], [1, 1, 1], [3, 0, 1], [2, 0, 1], [1, 1, 1]],
[[2, 0, 1], [1, 1, 1], [2, 0, 1], [1, 1, 1], [3, 0, 1], [2, 0, 1]],
[[1, 1, 1], [3, 0, 1], [1, 1, 1], [1, 1, 1], [1, 1, 1], [1, 1, 1]],
[[2, 0, 1], [1, 1, 1], [2, 0, 1], [1, 1, 1], [1, 1, 1], [2, 0, 1]],
[[3, 0, 1], [1, 1, 1], [3, 0, 1], [3, 0, 1], [1, 1, 1], [3, 0, 1]],
[[1, 1, 1], [2, 0, 1], [1, 1, 1], [2, 0, 1], [1, 1, 1], [3, 0, 1]]
]).

%prints the row coordinate
printNumber(N):- number(N, Number), write(Number), write('|').

%prints the cell points
printPoints(0, _Points):- write('    |').
printPoints(Color, Points):- Color\=0, write('/'), write(Points).

%prints the cell stack height
printStack(0, _Stack).
printStack(Color, Stack):- Color\=0, write('/'), write(Stack), write('|').

%prints the cell
printCell([Color, Points, Stack]):-
        code(Color, Character),
        write(Character),
        printPoints(Color, Points),
        printStack(Color, Stack).

%prints the line, cell by cell
printLine([]).
printLine([Cell | Line]):- printCell(Cell), printLine(Line).

%prints a dashed separator
printSeparator(1):- write(' |-----|-----|-----|-----|-----|-----|'), nl, printSeparator(2).
printSeparator(2):- write(' |     |     |     |     |     |     |'), nl.

%prints the board, line by line
printTab([], 0, _Player):- write(' |-----|-----|-----|-----|-----|-----|'), nl.
printTab([Line|B], N, Player):- 
        printSeparator(1),
        printNumber(N),
        printLine(Line),
        printInfo(N, Player), nl,
        printSeparator(2),
        N1 is N-1, printTab(B, N1, Player).

%o tabuleiro vai ser de tamanho NxN
printBoard(X, N, Player):- printHeader, printTab(X, N, Player).

%prints the board columns and cell key 
printHeader:-
    write('Cell Format: Color/Points/StackHeight\n\n'),
    write('    A     B     C     D     E     F    \n').

%prints the player turn on the first line
printInfo(6, 0):- write(' It is black\'s turn!').
printInfo(6, 1):- write(' It is white\'s turn!').
printInfo(_N, _Player).

%prints the current points
printPlayersPoints([[0, BlackPoints], [1, WhitePoints]]):- printBlackPoints(BlackPoints), printWhitePoints(WhitePoints).
printPlayersPoints([[1, WhitePoints], [0, BlackPoints]]):- printBlackPoints(BlackPoints), printWhitePoints(WhitePoints).

%prints the current black points
printBlackPoints(1):- write('\n\n  Black: 1 point\n').
printBlackPoints(Points):- write('\n  Black: '), write(Points), write(' points\n').

%prints the current white points
printWhitePoints(1):- write('  White: 1 point\n\n').
printWhitePoints(Points):- write('  White: '), write(Points), write(' points\n\n').