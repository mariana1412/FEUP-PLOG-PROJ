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
        Player = [[0, _], _],
        readMove(Player, GameState, StartCell, StartCol, StartRow, EndCell, EndCol, EndRow), !,
        updatePoints(Player, StartCell, EndCell, NewPlayer),
        updateBoardGame(StartCell, StartCol, StartRow, EndCell, EndCol, EndRow, GameState, NewState),
        NewGameState = [NewState, NewPlayer].

move(Player, GameState, NewGameState):-
        Player = [[1, _], _],
        sleep(2),
        value(GameState, Player, Value),
        nl, write('Computer plays '), displayMove(Value), nl, nl,
        sleep(2),
        Value = [[StartCol, StartRow], [EndCol, EndRow]],
        getCell(GameState, StartCol, StartRow, StartCell),
        getCell(GameState, EndCol, EndRow, EndCell),
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
        \+ hasAvailableMoves(GameState, Player),
        changePlayer(Player, NextPlayer),
        \+ hasAvailableMoves(GameState, NextPlayer).

finishGame(GameState):-
        nl, write('================================== GAME OVER ==================================\n'),
        notrace,
        game_over(GameState, Winner),
        displayGameOver(Winner), notrace.

game_over(GameState, Winner):- 
        countPointsStack(GameState, BlackPoints, BlackHighestStack, WhitePoints, WhiteHighestStack),
        displayPointsStack(BlackPoints, BlackHighestStack, WhitePoints, WhiteHighestStack),
        getWinner(BlackPoints, BlackHighestStack, WhitePoints, WhiteHighestStack, Winner).

getWinner(BlackPoints, _, WhitePoints, _, Winner):- BlackPoints>WhitePoints, Winner = 0.
getWinner(BlackPoints, _, WhitePoints, _, Winner):- BlackPoints<WhitePoints, Winner = 1.
getWinner(Points, BlackHighestStack, Points, WhiteHighestStack, Winner):- BlackHighestStack>WhiteHighestStack, Winner = 0.
getWinner(Points, BlackHighestStack, Points, WhiteHighestStack, Winner):- BlackHighestStack<WhiteHighestStack, Winner = 1.
getWinner(Points, Stack, Points, Stack, 2).