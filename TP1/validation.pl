%start cell cannot be empty and players can only move their own pieces
validateStart(Cell, Player):- 
        \+ isEmpty(Cell),
        validatePlayer(Cell, Player).

%end cell cannot be empty
validateEnd(Cell):- 
        \+ isEmpty(Cell).

%players can only move their own pieces
validatePlayer([2|_], [[0|_]|_]).
validatePlayer([3|_], [[1|_]|_]).

%validates move following all the rules
validateMove(StartCol, StartRow, EndCol, EndRow, GameState):-
        [StartCol,StartRow]\=[EndCol,EndRow],
        isReachable(StartCol, StartRow, EndCol, EndRow),
        validMove(StartCol, StartRow, EndCol, EndRow, GameState).

%players can only move pieces orthogonally
isReachable(StartCol, StartRow, EndCol, EndRow):-
        StartCol=:=EndCol;
        StartRow=:=EndRow.

validMove(Col, StartRow, Col, EndRow, GameState):-
        StartRow < EndRow,
        NewRow is (StartRow+1),
        validRow(Col, NewRow, EndRow, GameState).

validMove(Col, StartRow, Col, EndRow, GameState):-
        StartRow > EndRow,
        NewRow is (EndRow+1),
        validRow(Col, NewRow, StartRow, GameState).

validMove(StartCol, Row, EndCol, Row, GameState):-
        StartCol < EndCol,
        NewCol is (StartCol+1),
        validCol(Row, NewCol, EndCol, GameState).

validMove(StartCol, Row, EndCol, Row, GameState):-
        StartCol > EndCol,
        NewCol is (EndCol+1),
        validCol(Row, NewCol, StartCol, GameState).

validRow(_, Row, Row, _).
validRow(Col, StartRow, EndRow, GameState):-
        getCell(GameState, Col, StartRow, Cell),
        isEmpty(Cell),
        NewRow is(StartRow+1),
        validRow(Col, NewRow, EndRow, GameState).

validCol(_, Col, Col, _).
validCol(Row, StartCol, EndCol, GameState):-
        getCell(GameState, StartCol, Row, Cell),
        isEmpty(Cell),
        NewCol is(StartCol+1),
        validCol(Row, NewCol, EndCol, GameState).
        