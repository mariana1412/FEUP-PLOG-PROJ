getCell(GameState, CellCol, CellRow, Cell):-
        nth1(CellRow, GameState, Row),
        nth1(CellCol, Row, Cell).

updateCell([SC, SP, SS], [_EC, EP, ES], [NC, NP, NS]):-
        NC = SC,
        NP is (SP + EP),
        NS is (SS + ES).

updateBoardGame(StartCell, StartCol, StartRow, EndCell, EndCol, EndRow, GameState, NewState):-
        updateCell(StartCell, EndCell, NewCell),
        updateBoard(GameState, StartCol, StartRow, [0, 0, 0], AuxState), %remove StartCell
        updateBoard(AuxState, EndCol, EndRow, NewCell, NewState). %add new values to the EndCell

updateBoard(GameState, Col, Row, Cell, NewState):- Row1 is Row-1, Col1 is Col-1, updateRow(GameState, Col1, Row1, Cell, NewState).

updateRow([H|T], Col, 0, Cell, [NH|T]) :- updateColumn(H, Col, Cell, NH).
updateRow([H|T], Col, Row, Cell, [H|NT]) :-
        Row1 is (Row-1),
        updateRow(T, Col, Row1, Cell, NT).

updateColumn([_H|T], 0, Cell, [Cell|T]).
updateColumn([H|T], Col, Cell, [H|NT]) :- 
        Col1 is (Col-1),
        updateColumn(T, Col1, Cell, NT).

isEmpty([0, _, _]).

changePlayer([[Color, Points], [Color1, Points1]], Player) :- Player = [[Color1, Points1], [Color, Points]].

updatePoints(Player, [X|_], [X|_], Player). %capturing piece of the same color
updatePoints([[Color, Points], Player], _, [1, 1|_], [[Color, NP], Player]):- NP is (Points + 1). 
updatePoints([[Color, Points], [Color1, Points1]], [X|_], [Y, Add|_], [[Color, NP], [Color1, NP1]]):-
            X\=Y, Y\=1,
            NP is (Points + Add),
            write('------------- NP = '), write(NP), write('\t'), write(Points), write('+'), write(Add), nl,
            NP1 is (Points1 - Add),
            write('------------- NP1 = '), write(NP1), write('\t'), write(Points1), write('-'), write(Add), nl.
        