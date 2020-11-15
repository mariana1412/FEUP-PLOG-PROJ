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
        sizeBoard(GameState, NoCol, NoRow).
        %availableMoves(GameState, Color, ..., ListOfMoves).

         