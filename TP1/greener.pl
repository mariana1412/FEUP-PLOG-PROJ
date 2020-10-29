:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').
:-include('input.pl').
:-include('validation.pl').
:-include('play.pl').

play :- initial(GameState),
        Player=[[0, 0], [1, 0]], %o que estiver em primeiro é quem joga, o segundo elemento das sublistas é o numero de pontos
        printPlayersPoints(Player),
        display_game(GameState, Player),
        gameLoop(GameState, Player).
