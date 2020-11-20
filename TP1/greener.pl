:-use_module(library(lists)).
:-use_module(library(system)).
:-include('display.pl').
:-include('utils.pl').
:-include('input.pl').
:-include('logic.pl').
:-include('play.pl').
:-include('computer.pl').

%main function -> it initializes the board and
play :- initial(GameState),
        Player=[[0, 0], [1, 0]], %the first element represents the next player and the second element of each sublist represents the points
        display_game(GameState, Player),
        gameLoop(GameState, Player).

