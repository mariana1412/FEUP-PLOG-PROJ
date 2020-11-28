%prints the current game state
display_game(GameState, Player) :- 
        write('====================================================================\n'),
        printPlayersPoints(Player),
        Player = [[Color|_]|_],
        printBoard(GameState, Color).

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

processTurn(Player, GameState, NewGameState):- 
        hasAvailableMoves(GameState, Player),
        getMove(GameState, Player, Move),
        move(Move, [GameState, Player], NewGameState).
processTurn(Player, GameState, [GameState, Player]):- write('\nPlayer does not have available moves! Skipping turn!\n\n'), sleep(1).

getMove(GameState, Player, Move):-
        Player = [[_, _, 0], _], !,
        readMove(Player, GameState, StartCell, StartCol, StartRow, EndCell, EndCol, EndRow), !,
        M = [[StartCol, StartRow], [EndCol, EndRow]], nl,
        displayMovePlayer(Player, M),
        Move = [[StartCell, StartCol, StartRow], [EndCell, EndCol, EndRow]],
        sleep(1).

getMove(GameState, Player, Move):-
        Player = [[_, _, Level], _],
        nl, write('Computer is thinking...'), nl,
        choose_move(GameState, Player, Level, M),
        sleep(2),
        displayMovePlayer(Player, M),
        getCell(GameState, StartCol, StartRow, StartCell),
        getCell(GameState, EndCol, EndRow, EndCell),
        Move = [[StartCell, StartCol, StartRow], [EndCell, EndCol, EndRow]],
        sleep(3).

getMove(GameState, Player, Move):-
        write('Invalid move. Try again!\n'),
        getMove(GameState, Player, Move).

%Processes a new move, update points and board
move(Move, GameState, NewGameState):-
        GameState = [CurrentState, Player],
        Move = [[StartCell, StartCol, StartRow], [EndCell, EndCol, EndRow]],
        updatePoints(Player, StartCell, EndCell, NewPlayer),
        updateBoardGame(StartCell, StartCol, StartRow, EndCell, EndCol, EndRow, CurrentState, NewState),
        NewGameState = [NewState, NewPlayer].

hasAvailableMoves(GameState, Player):-
        valid_moves(GameState, Player, ListOfMoves), !,
        ListOfMoves \= [].

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