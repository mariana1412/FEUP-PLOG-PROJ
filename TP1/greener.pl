:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').
:-include('input.pl').

changePlayer(X, Y) :- Y is 1-X.

display_game(GameState, Player) :- printBoard(GameState, 6, Player, 5, 3).

play :- initial(X), changePlayer(1, P), display_game(X, P).

%display_game(+GameState, +Player) :- printBoard(GameState, 6, Player), nextMove(Player, GameState, NewState), changePlayer(Player, NewPlayer), display_game(NewState, NewPlayer).

%predicateRemove(GameState, Column, Row, Color, Points, Stack, NewState) :- accessCell(GameState, Column, Row, Cell), Cell is [0, 0, 0].

%predicateAdd(GameState, Column, Row, Color, Points, Stack).

%nextMove(currentPlayer, GameState, NewState) :- getMove(ColumnS, RowS, ColumnE, RowE), 

