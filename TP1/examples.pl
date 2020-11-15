%mid board setup
mid([
[[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [2, 1, 2]],
[[0, 0, 0], [0, 0, 0], [0, 0, 0], [2, 4, 7], [0, 0, 0], [0, 0, 0]],
[[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [1, 1, 1]],
[[0, 0, 0], [0, 0, 0], [3, 7, 17], [0, 0, 0], [0, 0, 0], [0, 0, 0]],
[[0, 0, 0], [1, 1, 1], [0, 0, 0], [0, 0, 0], [1, 1, 1], [3, 0, 1]],
[[2, 1, 2], [0, 0, 0], [3, 1, 2], [0, 0, 0], [1, 1, 1], [3, 0, 1]]
]).

%final board setup
final([
[[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]],
[[0, 0, 0], [0, 0, 0], [0, 0, 0], [2, 4, 7], [0, 0, 0], [0, 0, 0]],
[[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [3, 2, 4]],
[[0, 0, 0], [0, 0, 0], [3, 7, 17], [0, 0, 0], [0, 0, 0], [0, 0, 0]],
[[0, 0, 0], [3, 3, 4], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]],
[[3, 2, 4], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]
]).

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