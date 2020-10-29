validateStart(Cell, Player):- 
        \+ isEmpty(Cell),
        validatePlayer(Cell, Player).

validateEnd(Cell):- 
        \+ isEmpty(Cell).
    
validatePlayer([2|_], [[0|_]|_]).
validatePlayer([3|_], [[1|_]|_]).

validateMove(StartCol, StartRow, EndCol, EndRow, _GameState):-
        isReachable(StartCol, StartRow, EndCol, EndRow). %faltam verificações aqui

isReachable(StartCol, StartRow, EndCol, EndRow):-
        StartCol=:=EndCol;
        StartRow=:=EndRow.