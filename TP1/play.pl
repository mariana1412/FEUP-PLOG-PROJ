display_game(GameState, Player) :- 
        Player = [[Color|_]|_],
        printBoard(GameState, 6, Color).

gameLoop(GameState, Player):-
        nextMove(GameState, Player, NewPlayer, NewState), 
        (       
                (       
                        C\=C
                       %finishGame(GameState, Player).
                       %aqui vai se verificar se há mais jogadas possiveis -> se não houver, terminar o jogo. se huver, continuar
                );

                (
                        gameLoop(NewState, NewPlayer)
                )
        ).
        
nextMove(GameState, Player, NewPlayer, NewState):- 
        move(Player, GameState, NewGameState), !,
        nth0(0, NewGameState, NewState),
        nth0(1, NewGameState, NewP),
        changePlayer(NewP, NewPlayer),
        display_game(NewState, NewPlayer).        


move(Player, GameState, NewGameState) :- %NewGameState é uma lista com [NewGameState, NewPlayer] 
        %falta verificar se o player tem jogadas possíveis
        (
            (
                readMove(Player, GameState, StartCell, StartCol, StartRow, EndCell, EndCol, EndRow), !,
                updatePoints(Player, StartCell, EndCell, NewPlayer),
                updateBoardGame(StartCell, StartCol, StartRow, EndCell, EndCol, EndRow, GameState, NewState),
                printPlayersPoints(NewPlayer),
                NewGameState = [NewState, NewPlayer]
            );
            (
                write('Invalid move. Try again!\n'),
                move(Player, GameState, NewState)
            )
        ).
