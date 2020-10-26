:-use_module(library(lists)).
:-include('display.pl').
:-include('utils.pl').

changePlayer(X, Y) :- Y is 1-X.

display_game(GameState, Player) :- printBoard(GameState, 6, Player, 5, 3).

play :- initial(X), changePlayer(1, P), display_game(X, P).

%letter(1, 'A').
%letter(2, 'B').
%letter(3, 'C').
%letter(4, 'D').
%letter(5, 'E').
%letter(6, 'F').

%display_game(+GameState, +Player) :- printBoard(GameState, 6, Player), nextMove(Player, GameState, NewState), changePlayer(Player, NewPlayer), display_game(NewState, NewPlayer).

%getCell(Column, Row) :- write('Column: '), get_char(C), nl, write('Row: '), get_char(Row), letter(Collumn, C).

%getStart(Column, Row) :- write('Which piece are you gonna move?'), nl, getCell(Column, Row).

%getEnd(Column, Row) :- write('Where are you moving it to?'), nl, getCell(Column, Row).

%getMove(ColumnS, RowS, ColumnE, RowE) :- getStart(ColumnS, RowS), nl, getEnd(ColumnE, RowE)).

%accessCell([], C, R, N).
%accessCell([H | T], C, R, N).

%accessLine([], C, R, N).
%accessLine([H|T], 0, R, N) :- accessCell(H).
%accessLine([H | T], C, R, N) :- accessCell(H), C\= 0, C1 is C-1, accessLine(T, C1, R, N).

%predicateRemove(GameState, Column, Row, Color, Points, Stack, NewState) :- accessCell(GameState, Column, Row, Cell), Cell is [0, 0, 0].

%predicateAdd(GameState, Column, Row, Color, Points, Stack).

%nextMove(currentPlayer, GameState, NewState) :- getMove(ColumnS, RowS, ColumnE, RowE), 



%ola(...):- N=row1, modifyRow(State, NewState), 
%ola(row1, row2, col1, col2, [],  N):- N\=row1, N\=row2, append(State, NewState, X), ola(); 

% !!!!!!!! TO DO: predicado de dar append e modificar celula;
% !!!!!!!! TO DO: predicado de aceder a celula e guardar uma lista; 