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
printCell([Color, Points]):- code(Color, Character), write(Character), write(Points), write('|').
printLine([]).
printLine([Cell | Line]):- printCell(Cell), printLine(Line).
printBoard([]):- write('|--|--|--|--|--|--|'), nl.
printBoard([Line | B]):- write('|--|--|--|--|--|--|'), nl, write('|'), printLine(Line), nl, printBoard(B).