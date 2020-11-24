cellValidMoves(GameState, Player, Column, Row, ValidMoves):-
        valid_moves(GameState, Player, ListMoves),
        Cell = [Column, Row], !,
        getCellValidMoves(Cell, ListMoves, [], ValidMoves).

getCellValidMoves(_, [], AuxMoves, ValidMoves):-
        ValidMoves = AuxMoves.

getCellValidMoves(Cell, [H|T], AuxMoves, ValidMoves):- 
        H = [Cell|_],
        append(AuxMoves, [H], Moves),
        getCellValidMoves(Cell, T, Moves, ValidMoves).

getCellValidMoves(Cell, [H|T], AuxMoves, ValidMoves):-
        H \= [Cell|_],
        getCellValidMoves(Cell, T, AuxMoves, ValidMoves).

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
        append(M, Moves, NewMoves),
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
        availableUpMove(GameState, PreviousRow, CurrentCol, MoveUp),
        addMove(MoveUp, [], CurrentCol, CurrentRow, MovesUp),
        availableLeftMove(GameState, CurrentRow, PreviousCol, MoveLeft),
        addMove(MoveLeft, MovesUp, CurrentCol, CurrentRow, MovesLeft),
        availableRightMove(GameState, CurrentRow, NextCol, MaxCol, MoveRight),
        addMove(MoveRight, MovesLeft, CurrentCol, CurrentRow, MovesRight),
        availableDownMove(GameState, NextRow, CurrentCol, MaxRow, MoveDown),
        addMove(MoveDown, MovesRight, CurrentCol, CurrentRow, ListOfMoves).

availableRightMove(_, _, Col, Col, []).
availableRightMove(_, _, Col, Col, _).
availableRightMove(GameState, CurrentRow, CurrentCol, MaxCol, MoveRight):-
        getCell(GameState, CurrentCol, CurrentRow, Cell), !,
        checkRightCell(Cell, MaxCol, Col, CurrentCol, CurrentRow, MoveRight),
        availableRightMove(GameState, CurrentRow, Col, MaxCol, MoveRight).

availableLeftMove(_, _, -1, []).
availableLeftMove(_, _, -1, _).
availableLeftMove(GameState, CurrentRow, CurrentCol, MoveLeft):-
        getCell(GameState, CurrentCol, CurrentRow, Cell), !,
        checkLeftCell(Cell, Col, CurrentCol, CurrentRow, MoveLeft),
        availableLeftMove(GameState, CurrentRow, Col, MoveLeft).

availableUpMove(_, -1, _, []).
availableUpMove(_, -1, _, _).
availableUpMove(GameState, CurrentRow, CurrentCol, MoveUp):-
        getCell(GameState, CurrentCol, CurrentRow, Cell), !,
        checkUpCell(Cell, Row, CurrentRow, CurrentCol, MoveUp),
        availableUpMove(GameState, Row, CurrentCol, MoveUp).

availableDownMove(_, Row, _, Row, []).
availableDownMove(_, Row, _, Row, _).
availableDownMove(GameState, CurrentRow, CurrentCol, MaxRow, MoveDown):-
        getCell(GameState, CurrentCol, CurrentRow, Cell), !,
        checkDownCell(Cell, MaxRow, Row, CurrentRow, CurrentCol, MoveDown),
        availableDownMove(GameState, Row, CurrentCol, MaxRow, MoveDown).