%prints the current game state
display_game(GameState, Player) :- 
        write('====================================================================\n'),
        printPlayersPoints(Player),
        Player = [[Color|_]|_],
        printBoard(GameState, 6, Color).

%Game cycle until there is no possible move
gameLoop(GameState, Player):- isFinished(GameState, Player), !, finishGame(GameState).
gameLoop(GameState, Player):-
        nextMove(GameState, Player, NewPlayer, NewState),
        gameLoop(NewState, NewPlayer).

%Processes a new move, changes player and displays new state and player 
nextMove(GameState, Player, NewPlayer, NewState):-
        processTurn(Player, GameState, NewGameState), 
        nth0(0, NewGameState, NewState),
        nth0(1, NewGameState, NewP),
        changePlayer(NewP, NewPlayer),
        display_game(NewState, NewPlayer).        

processTurn(Player, GameState, NewGameState):- hasAvailableMoves(GameState, Player), move(Player, GameState, NewGameState).
processTurn(Player, GameState, [GameState, Player]):- write('\nPlayer does not have available moves! Skipping turn!\n\n').

%Processes a new move, update points and board
move(Player, GameState, NewGameState):-
        readMove(Player, GameState, StartCell, StartCol, StartRow, EndCell, EndCol, EndRow), !,
        updatePoints(Player, StartCell, EndCell, NewPlayer),
        updateBoardGame(StartCell, StartCol, StartRow, EndCell, EndCol, EndRow, GameState, NewState),
        NewGameState = [NewState, NewPlayer].

move(Player, GameState, NewGameState):-
        write('Invalid move. Try again!\n'),
        move(Player, GameState, NewGameState).

hasAvailableMoves(GameState, Player):-
        valid_moves(GameState, Player, ListOfMoves), !,
        ListOfMoves \= [].

isFinished(GameState, Player):- 
        Player = [[Color|_]|_], 
        noPlayerPieces(GameState, Color).

isFinished(GameState, Player):- 
        changePlayer(Player, NP),
        NP = [[Color|_]|_], 
        noPlayerPieces(GameState, Color).

isFinished(GameState, Player):-
        \+ hasAvailableMoves(GameState, Player),
        changePlayer(Player, NextPlayer),
        \+ hasAvailableMoves(GameState, NextPlayer).

finishGame(GameState):-
        nl, write('================================== GAME OVER ==================================\n'),
        game_over(GameState, Winner),
        displayGameOver(Winner).

game_over(GameState, Winner):- 
        countPointsStack(GameState, BlackPoints, BlackHighestStack, WhitePoints, WhiteHighestStack),
        displayPointsStack(BlackPoints, BlackHighestStack, WhitePoints, WhiteHighestStack),
        getWinner(BlackPoints, BlackHighestStack, WhitePoints, WhiteHighestStack, Winner).

getWinner(BlackPoints, _, WhitePoints, _, Winner):- BlackPoints>WhitePoints, Winner = 0.
getWinner(BlackPoints, _, WhitePoints, _, Winner):- BlackPoints<WhitePoints, Winner = 1.
getWinner(Points, BlackHighestStack, Points, WhiteHighestStack, Winner):- BlackHighestStack>WhiteHighestStack, Winner = 0.
getWinner(Points, BlackHighestStack, Points, WhiteHighestStack, Winner):- BlackHighestStack<WhiteHighestStack, Winner = 1.
getWinner(Points, Stack, Points, Stack, 2).

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
        availableDownMove(GameState, NextCol, CurrentRow, MaxCol, MoveDown),
        availableUpMove(GameState, PreviousCol, CurrentRow, MoveUp),
        append4Lists(MoveRight, MoveLeft, MoveUp, MoveDown, Final),
        deleteEmptyList(Final, CleanFinal),
        addMove(CleanFinal, ListOfMoves, CurrentCol, CurrentRow).

availableRightMove(_, _, Row, Row, []).
availableRightMove(_, _, Row, Row, _).
availableRightMove(GameState, CurrentCol, CurrentRow, MaxRow, MoveRight):-
        ColAux is (CurrentCol+1), RowAux is (CurrentRow+1),
        getCell(GameState, ColAux, RowAux, Cell), !,
        checkRightCell(Cell, MaxRow, Row, CurrentRow, CurrentCol, MoveRight),
        availableRightMove(GameState, CurrentCol, Row, MaxRow, MoveRight).

availableLeftMove(_, _, -1, []).
availableLeftMove(_, _, -1, _).
availableLeftMove(GameState, CurrentCol, CurrentRow, MoveLeft):-
        ColAux is (CurrentCol+1), RowAux is (CurrentRow+1),
        getCell(GameState, ColAux, RowAux, Cell), !,
        checkLeftCell(Cell, Row, CurrentRow, CurrentCol, MoveLeft),
        availableLeftMove(GameState, CurrentCol, Row, MoveLeft).

availableUpMove(_, -1, _, []).
availableUpMove(_, -1, _, _).
availableUpMove(GameState, CurrentCol, CurrentRow, MoveUp):-
        ColAux is (CurrentCol+1), RowAux is (CurrentRow+1),
        getCell(GameState, ColAux, RowAux, Cell), !,
        checkUpCell(Cell, Col, CurrentCol, CurrentRow, MoveUp),
        availableUpMove(GameState, Col, CurrentRow, MoveUp).

availableDownMove(_, Col, _, Col, []).
availableDownMove(_, Col, _, Col, _).
availableDownMove(GameState, CurrentCol, CurrentRow, MaxCol, MoveDown):-
        ColAux is (CurrentCol+1), RowAux is (CurrentRow+1),
        getCell(GameState, ColAux, RowAux, Cell), !,
        checkDownCell(Cell, MaxCol, Col, CurrentCol, CurrentRow, MoveDown),
        availableDownMove(GameState, Col, CurrentRow, MaxCol, MoveDown).