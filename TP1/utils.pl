accessCell(GameState, CellCol, CellRow, Cell):-
    nth1(CellRow, GameState, Row),
    nth1(CellCol, Row, Cell).

updateBoard(GameState, Col, Row, Cell, NewState):- Row1 is Row-1, Col1 is Col-1, updateRow(GameState, Col1, Row1, Cell, NewState).

updateRow([H|T], Col, 0, Cell, [NH|T]) :- updateColumn(H, Col, Cell, NH).
updateRow([H|T], Col, Row, Cell, [H|NT]) :-
    Row1 is (Row-1),
    updateRow(T, Col, Row1, Cell, NT).

updateColumn([_H|T], 0, Cell, [Cell|T]).
updateColumn([H|T], Col, Cell, [H|NT]) :- 
    Col1 is (Col-1),
    updateColumn(T, Col1, Cell, NT).