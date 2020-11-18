cellValidMoves(GameState, Player, Column, Row, ValidMoves):-
        valid_moves(GameState, Player, ListMoves),
        Cell = [Column, Row], !,
        getCellValidMoves(Cell, ListMoves, ValidMoves).

getCellValidMoves(_, [], []).

getCellValidMoves(Cell, [H|_], CellMoves):- 
        H = [Cell|_],
        CellMoves = H.

getCellValidMoves(Cell, [H|T], CellMoves):-
        H \= [Cell|_],
        getCellValidMoves(Cell, T, CellMoves).

valid_moves(GameState, Player, ListOfMoves):-
        Player = [[Color|_]|_],
        sizeBoard(GameState, MaxCol, MaxRow),
        availableMoves(GameState, Color, 0, MaxCol, MaxRow, _List, MovesList),
        append(MovesList, [], ListOfMoves).

availableMoves(_, _, Index, MaxCol, MaxRow, List, ListMoves):- Index is (MaxCol*MaxRow), ListMoves = List.
availableMoves(GameState, Player, Index, MaxCol, MaxRow, List, ListMoves):-
        getColRowbyIndex(Index, CurrentCol, CurrentRow, MaxCol),
        availableCell(GameState, Player, CurrentCol, CurrentRow, MaxCol, MaxRow, Moves),
        NextIndex is (Index+1),
        append(List, [], M),
        append(M, [Moves], NewMoves),
        deleteEmptyList(NewMoves, CleanMoves),
        availableMoves(GameState, Player, NextIndex, MaxCol, MaxRow, CleanMoves, ListMoves).

availableCell(GameState, 1, CurrentCol, CurrentRow, _, _, ListOfMoves):-
        getCell(GameState, CurrentCol, CurrentRow, Cell),
        Cell = [P|_],
        P \= 3,
        ListOfMoves = [].

availableCell(GameState, 0, CurrentCol, CurrentRow, _, _, ListOfMoves):-
        getCell(GameState, CurrentCol, CurrentRow, Cell),
        Cell = [P|_],
        P \= 2,
        ListOfMoves = [].

availableCell(GameState, _, CurrentCol, CurrentRow, MaxCol, MaxRow, ListOfMoves):-
        NextRow is (CurrentRow+1), PreviousRow is (CurrentRow-1), NextCol is (CurrentCol+1), PreviousCol is (CurrentCol-1),
        availableRightMove(GameState, CurrentCol, NextRow, MaxRow, MoveRight),
        availableLeftMove(GameState, CurrentCol, PreviousRow, MoveLeft),
        availableDownMove(GameState, NextCol, CurrentRow, MaxCol, MoveDown),
        availableUpMove(GameState, PreviousCol, CurrentRow, MoveUp), 
        append4Lists(MoveUp, MoveLeft, MoveRight, MoveDown, Final), 
        deleteEmptyList(Final, CleanFinal),
        addMove(CleanFinal, ListOfMoves, CurrentCol, CurrentRow).

availableRightMove(_, _, Row, Row, []).
availableRightMove(_, _, Row, Row, _).
availableRightMove(GameState, CurrentCol, CurrentRow, MaxRow, MoveRight):-
        getCell(GameState, CurrentCol, CurrentRow, Cell), !,
        checkRightCell(Cell, MaxRow, Row, CurrentRow, CurrentCol, MoveRight),
        availableRightMove(GameState, CurrentCol, Row, MaxRow, MoveRight).

availableLeftMove(_, _, -1, []).
availableLeftMove(_, _, -1, _).
availableLeftMove(GameState, CurrentCol, CurrentRow, MoveLeft):-
        getCell(GameState, CurrentCol, CurrentRow, Cell), !,
        checkLeftCell(Cell, Row, CurrentRow, CurrentCol, MoveLeft),
        availableLeftMove(GameState, CurrentCol, Row, MoveLeft).

availableUpMove(_, -1, _, []).
availableUpMove(_, -1, _, _).
availableUpMove(GameState, CurrentCol, CurrentRow, MoveUp):-
        getCell(GameState, CurrentCol, CurrentRow, Cell), !,
        checkUpCell(Cell, Col, CurrentCol, CurrentRow, MoveUp),
        availableUpMove(GameState, Col, CurrentRow, MoveUp).

availableDownMove(_, Col, _, Col, []).
availableDownMove(_, Col, _, Col, _).
availableDownMove(GameState, CurrentCol, CurrentRow, MaxCol, MoveDown):-
        getCell(GameState, CurrentCol, CurrentRow, Cell), !,
        checkDownCell(Cell, MaxCol, Col, CurrentCol, CurrentRow, MoveDown),
        availableDownMove(GameState, Col, CurrentRow, MaxCol, MoveDown).