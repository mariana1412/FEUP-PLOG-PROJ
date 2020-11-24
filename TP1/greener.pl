:-use_module(library(lists)).
:-use_module(library(system)).
:-use_module(library(random)).
:-include('display.pl').
:-include('utils.pl').
:-include('input.pl').
:-include('logic.pl').
:-include('play.pl').
:-include('computer.pl').

%main function -> it initializes the board and
play :- getPlayerOptions(Player),
        getInitialGameState(GameState),
        display_game(GameState, Player),
        gameLoop(GameState, Player).

