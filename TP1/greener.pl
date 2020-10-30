:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').
:-include('input.pl').
:-include('validation.pl').
:-include('play.pl').

%main function -> it initializes the board and
play :- initial(GameState),
        Player=[[0, 0], [1, 0]], %the first element represents the next player and the second element of each sublist represents the points
        printPlayersPoints(Player),
        display_game(GameState, Player),
        gameLoop(GameState, Player).

%para mostrar o tabuleiro de jogo intermédio (mid.png)
%play :- mid(GameState),
%        Player=[[1, 8], [0, 6]], 
%        printPlayersPoints(Player),
%        display_game(GameState, Player),
%        gameLoop(GameState, Player).

%para mostrar o tabuleiro de jogo final (final.png)
%play :- final(GameState),
%        Player=[[0, 4], [1, 14]], 
%        printPlayersPoints(Player),
%        display_game(GameState, Player),
%        gameLoop(GameState, Player).