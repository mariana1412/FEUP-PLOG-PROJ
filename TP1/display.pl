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
printPoints(0, _Points):- write('     |').
printPoints(Color, Points):- Color\=0, format('~|~`0t~d~2+', Points).

%prints the cell stack height
printStack(0, _Stack).
printStack(Color, Stack):- Color\=0, write('/'), format('~|~`0t~d~2+', Stack), write('|').

%prints the cell color
printCellColor([Color, Points, Stack]) :-
        write('  '),
        code(Color, Character),
        write(Character),
        write('  |').

%prints the cell Points and Stack Height
printCellPointsStack([Color, Points, Stack]) :-
        printPoints(Color, Points),
        printStack(Color, Stack).

printLineColor([]).
printLineColor([Cell | Line]):- printCellColor(Cell), printLineColor(Line).

printLinePointsStack([]).
printLinePointsStack([Cell | Line]):- printCellPointsStack(Cell), printLinePointsStack(Line).

%prints a dashed separator
printSeparator(1):- write(' |-----|-----|-----|-----|-----|-----|'), nl.
printSeparator(2):- write('     |     |     |     |     |     |').

%prints the board, line by line
printTab([], 0, _Player):- write(' |-----|-----|-----|-----|-----|-----|'), nl.

printTab([Line|B], N, Player):- 
        printSeparator(1),
        write(' |'),
        printLineColor(Line), nl,
        printNumber(N),
        printSeparator(2),
        printInfo(N, Player), nl,
        write(' |'),
        printLinePointsStack(Line), nl,
        N1 is N-1, printTab(B, N1, Player).

%o tabuleiro vai ser de tamanho NxN
printBoard(X, N, Player):- printHeader, printTab(X, N, Player).

%prints the board columns and cell key 
printHeader:-
    write('\n    A     B     C     D     E     F    '),
    write('Cell Format: Color/Points/StackHeight\n').

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

displayGameOver(0):- write('Black is the winner! Congrats!\n').
displayGameOver(1):- write('White is the winner! Congrats!\n').
displayGameOver(2):- write('I\'ts a tie!\n').

displayPointsStack(BlackPoints, BlackHighestStack, WhitePoints, WhiteHighestStack):-
        write('Black ----> Points = '), write(BlackPoints), write(', Highest Stack: '), write(BlackHighestStack), nl,
        write('White ----> Points = '), write(WhitePoints), write(', Highest Stack: '), write(WhiteHighestStack), nl.