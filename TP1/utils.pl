%get cell content from GameState
getCell(GameState, CellCol, CellRow, Cell):-
        nth1(CellRow, GameState, Row),
        nth1(CellCol, Row, Cell).

%get size of Board
sizeBoard(GameState, NoCol, NoRow):-
        length(GameState, NoRow),
        nth0(0, GameState, Row),
        length(Row, NoCol).

%creates a new cell according to the move
updateCell([SC, SP, SS], [_EC, EP, ES], [NC, NP, NS]):-
        NC = SC,
        NP is (SP + EP),
        NS is (SS + ES).

%updates Cell, makes the StartCell empty, replaces EndCell content with the NewCell content
updateBoardGame(StartCell, StartCol, StartRow, EndCell, EndCol, EndRow, GameState, NewState):-
        updateCell(StartCell, EndCell, NewCell),
        updateBoard(GameState, StartCol, StartRow, [0, 0, 0], AuxState), %remove StartCell
        updateBoard(AuxState, EndCol, EndRow, NewCell, NewState). %add new values to the EndCell

%makes sure that the index of first row/column is 0, updates Board
updateBoard(GameState, Col, Row, Cell, NewState):- Row1 is Row-1, Col1 is Col-1, updateRow(GameState, Col1, Row1, Cell, NewState).

%when it is in the right row, it updates column; otherwise, updates row
updateRow([H|T], Col, 0, Cell, [NH|T]) :- updateColumn(H, Col, Cell, NH).
updateRow([H|T], Col, Row, Cell, [H|NT]) :-
        Row1 is (Row-1),
        updateRow(T, Col, Row1, Cell, NT).

%when it is in the right column, replace it with the new cell; otherwise, updates column
updateColumn([_H|T], 0, Cell, [Cell|T]).
updateColumn([H|T], Col, Cell, [H|NT]) :- 
        Col1 is (Col-1),
        updateColumn(T, Col1, Cell, NT).

%is Empty, when first element is 0
isEmpty([0, _, _]).

%changes order of sublists
changePlayer([[Color, Points], [Color1, Points1]], Player) :- Player = [[Color1, Points1], [Color, Points]].

%update Player points
updatePoints(Player, [X|_], [X|_], Player). %capturing piece of the same color
updatePoints([[Color, Points], Player], _, [1, 1|_], [[Color, NP], Player]):- NP is (Points + 1). %capturing green piece
updatePoints([[Color, Points], [Color1, Points1]], [X|_], [Y, Add|_], [[Color, NP], [Color1, NP1]]):- %capturing enemy piece, update both sublists
            X\=Y, Y\=1,
            NP is (Points + Add),
            NP1 is (Points1 - Add).
        