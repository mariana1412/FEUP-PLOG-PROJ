letter(6, 'A').
letter(5, 'B').
letter(4, 'C').
letter(3, 'D').
letter(2, 'E').
letter(1, 'F').

code(0, ' ').
code(1, 'G').
code(2, 'B').
code(3, 'W').

board([
[[1, 0], [2, 0], [1, 0], [2, 0], [1, 0], [2, 0]],
[[1, 0], [2, 0], [1, 0], [2, 0], [1, 0], [2, 0]],
[[1, 0], [2, 0], [1, 0], [3, 0], [1, 0], [2, 0]],
[[0, 1], [0, 1], [0, 1], [0, 1], [0, 1], [0, 1]],
[[3, 1], [0, 1], [3, 1], [1, 1], [0, 1], [3, 1]],
[[0, 1], [0, 1], [2, 1], [3, 1], [0, 1], [0, 1]]
]).

printLetter(N):- letter(N, Letter), write(' '), write(Letter), write(' |').

printPoints(0, _Points):- write('  |').
printPoints(Color, Points):- Color\=0, write(Points), write(' |').

printCell([Color, Points]):- code(Color, Character), write(Character), printPoints(Color, Points).

printLine([]).
printLine([Cell | Line]):- printCell(Cell), printLine(Line).

printTab([], 0):- write('---|---|---|---|---|---|---|'), nl.
printTab([Line|B], N):- write('---|---|---|---|---|---|---|'), nl, printLetter(N), printLine(Line), nl, N1 is N-1, printTab(B, N1).

%o tabuleiro vai ser de tamanho NxN
printBoard(X, N):- printHeader, printTab(X, N).

printHeader:-
    nl,
    write('   | 0 | 1 | 2 | 3 | 4 | 5 |\n').



