%prints the current game state
display_game(GameState, Player) :- 
        write('====================================================================\n'),
        printPlayersPoints(Player),
        Player = [[Color|_]|_],
        printBoard(GameState, 6, Color).

%Game cycle until there is no possible move
gameLoop(GameState, Player):-
        nextMove(GameState, Player, NewPlayer, NewState), 
        (       
                (       
                        C\=C %to delete
                       % TO DO: finishGame(GameState, Player).
                );

                (
                        gameLoop(NewState, NewPlayer)
                )
        ).

%Processes a new move, changes player and displays new state and player 
nextMove(GameState, Player, NewPlayer, NewState):- 
        move(Player, GameState, NewGameState), !,
        nth0(0, NewGameState, NewState),
        nth0(1, NewGameState, NewP),
        changePlayer(NewP, NewPlayer),
        display_game(NewState, NewPlayer).        

%Processes a new move, update points and board
move(Player, GameState, NewGameState) :- 
        %it will be checked if the player has possible moves
        (
            (
                readMove(Player, GameState, StartCell, StartCol, StartRow, EndCell, EndCol, EndRow), !,
                updatePoints(Player, StartCell, EndCell, NewPlayer),
                updateBoardGame(StartCell, StartCol, StartRow, EndCell, EndCol, EndRow, GameState, NewState),
                NewGameState = [NewState, NewPlayer]
            );
            (
                write('Invalid move. Try again!\n'),
                move(Player, GameState, NewGameState)
            )
        ).

valid_moves(GameState, Player, ListOfMoves):-
        Player = [[Color|_]|_],
        write('Player = '), write(Color), nl,
        sizeBoard(GameState, MaxCol, MaxRow),
        CurrentCol is (MaxCol-1), CurrentRow is (MaxRow-1),
        availableMoves(GameState, Color, CurrentCol, CurrentRow, MaxCol, MaxRow, ListOfMoves),
        write('---> '), write(ListOfMoves), write(' <--- \n').

availableMoves(_, _, -1, -1, _, _, []).
availableMoves(_, _, -1, -1, _, _, _).
availableMoves(GameState, Player, CurrentCol, CurrentRow, MaxCol, MaxRow, ListOfMoves):-
        write('ROWWWWWWWWWWWW\n'),
        CC = CurrentCol,
        CR = CurrentRow,
        availableRow(GameState, Player, CC, CR, MaxCol, MaxRow, ListOfMoves), !,
        write('COLLLLLLLLLLLL\n'),
        availableCol(GameState, Player, CC, CR, MaxCol, MaxRow, ListOfMoves), !,
        Col is (CurrentCol-1), Row is (CurrentRow-1),
        availableMoves(GameState, Player, Col, Row, MaxCol, MaxRow, ListOfMoves).

availableRow(_, _, _, -1, _, _, []).
availableRow(_, _, _, -1, _, _, _).
availableRow(GameState, Player, CurrentCol, CurrentRow, MaxCol, MaxRow, ListOfMoves):-
        write('ROW IS '), write(CurrentRow), write('! Col is '), write(CurrentCol), write('! List: '), write(ListOfMoves), nl,
        availableCell(GameState, Player, CurrentCol, CurrentRow, MaxCol, MaxRow, Moves), !,
        (
                (
                        Moves \= [], !,
                        append(ListOfMoves, [], M),
                        append(M, [Moves], NewMoves)
                );
                (
                        NewMoves = ListOfMoves
                )
        ),
        Row is (CurrentRow-1), 
        availableRow(GameState, Player, CurrentCol, Row, MaxCol, MaxRow, NewMoves).

availableCol(_, _, -1, _, _, _, []).
availableCol(_, _, -1, _, _, _, _).
availableCol(GameState, Player, CurrentCol, CurrentRow, MaxCol, MaxRow, ListOfMoves):-
        write('ROW IS '), write(CurrentRow), write('! Col is '), write(CurrentCol), write('! List: '), write(ListOfMoves), nl,
        availableCell(GameState, Player, CurrentCol, CurrentRow, MaxCol, MaxRow, Moves), !,
        (
                (
                        Moves \= [], !,
                        append(ListOfMoves, [], M),
                        append(M, [Moves], NewMoves)
                );
                (
                        NewMoves = ListOfMoves
                )
        ),
        Col is (CurrentCol-1), 
        availableCol(GameState, Player, Col, CurrentRow, MaxCol, MaxRow, NewMoves).

availableCell(GameState, 1, CurrentCol, CurrentRow, _, _, ListOfMoves):-
        Col is (CurrentCol+1), Row is (CurrentRow+1),
        getCell(GameState, Col, Row, Cell),
        Cell = [P|_],
        P \= 3,
        ListOfMoves = [].

availableCell(GameState, 0, CurrentCol, CurrentRow, _, _, ListOfMoves):-
        Col is (CurrentCol+1), Row is (CurrentRow+1),
        getCell(GameState, Col, Row, Cell),
        Cell = [P|_],
        P \= 2,
        ListOfMoves = [].

availableCell(GameState, _, CurrentCol, CurrentRow, MaxCol, MaxRow, ListOfMoves):-
        NextRow is (CurrentRow+1), PreviousRow is (CurrentRow-1), NextCol is (CurrentCol+1), PreviousCol is (CurrentCol-1),
        availableRightMove(GameState, CurrentCol, NextRow, MaxRow, MoveRight),
        availableLeftMove(GameState, CurrentCol, PreviousRow, MoveLeft),
        availableUpMove(GameState, PreviousCol, CurrentRow, MoveUp),
        availableDownMove(GameState, NextCol, CurrentRow, MaxCol, MoveDown),
        append([], MoveRight, Final1),
        append(Final1, MoveLeft, Final2),
        append(Final2, MoveUp, Final3),
        append(Final3, MoveDown, Final4),
        append([[CurrentCol, CurrentRow]], Final4, ListOfMoves).

availableRightMove(_, _, Row, Row, []).
availableRightMove(_, _, Row, Row, _).
availableRightMove(GameState, CurrentCol, CurrentRow, MaxRow, MoveRight):-
        ColAux is (CurrentCol+1), RowAux is (CurrentRow+1),
        getCell(GameState, ColAux, RowAux, Cell), !,
        (
                (
                        isEmpty(Cell),
                        Row is (CurrentRow+1),
                        availableRightMove(GameState, CurrentCol, Row, MaxRow, MoveRight)
                );
                (
                        NewMove = [[CurrentCol, CurrentRow]],
                        append([], NewMove, MoveRight),
                        availableRightMove(GameState, CurrentCol, MaxRow, MaxRow, MoveRight)
                )
        ).

availableLeftMove(_, _, -1, []).
availableLeftMove(_, _, -1, _).
availableLeftMove(GameState, CurrentCol, CurrentRow, MoveLeft):-
        ColAux is (CurrentCol+1), RowAux is (CurrentRow+1),
        getCell(GameState, ColAux, RowAux, Cell), !,
        (
                (
                        isEmpty(Cell),
                        Row is (CurrentRow-1),
                        availableLeftMove(GameState, CurrentCol, Row, MoveLeft)
                );
                (
                        NewMove = [[CurrentCol, CurrentRow]],
                        append([], NewMove, MoveLeft),
                        availableLeftMove(GameState, CurrentCol, -1, MoveLeft)
                )
        ).

availableUpMove(_, -1, _, []).
availableUpMove(_, -1, _, _).
availableUpMove(GameState, CurrentCol, CurrentRow, MoveUp):-
        ColAux is (CurrentCol+1), RowAux is (CurrentRow+1),
        getCell(GameState, ColAux, RowAux, Cell), !,
        (
                (
                        isEmpty(Cell),
                        Col is (CurrentCol-1),
                        availableUpMove(GameState, Col, CurrentRow, MoveUp)
                );
                (
                        NewMove = [[CurrentCol, CurrentRow]],
                        append([], NewMove, MoveUp),
                        availableUpMove(GameState, -1, CurrentRow, MoveUp)
                )
        ).

availableDownMove(_, Col, _, Col, []).
availableDownMove(_, Col, _, Col, _).
availableDownMove(GameState, CurrentCol, CurrentRow, MaxCol, MoveDown):-
        ColAux is (CurrentCol+1), RowAux is (CurrentRow+1),
        getCell(GameState, ColAux, RowAux, Cell), !,
        (
                (
                        isEmpty(Cell),
                        Col is (CurrentCol+1),
                        availableDownMove(GameState, Col, CurrentRow, MaxCol, MoveDown)
                );
                (
                        NewMove = [[CurrentCol, CurrentRow]],
                        append([], NewMove, MoveDown),
                        availableDownMove(GameState, MaxCol, CurrentRow, MaxCol, MoveDown)
                )
        ).