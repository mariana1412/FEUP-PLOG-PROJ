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
validateMove(StartCol, StartRow, EndCol, EndRow, _GameState):-
        isReachable(StartCol, StartRow, EndCol, EndRow). %not finished

%players can only move pieces orthogonally
isReachable(StartCol, StartRow, EndCol, EndRow):-
        StartCol=:=EndCol;
        StartRow=:=EndRow.