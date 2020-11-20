value(GameState, Player, Value):-
        valid_moves(GameState, Player, ListOfMoves),!,
        bestMove(GameState, Player, ListOfMoves, _, Value, -1, _).

bestMove(_, _, [], Move, FinalMove, Value, FinalValue):- FinalValue is Value, FinalMove = Move.

bestMove(GameState, Player, [H | T], _, FinalMove, Value, FinalValue):-
        %write('evaluating: '), print(H), nl,
        evaluateMove(GameState, Player, H, MoveValue),
        MoveValue > Value, !,
        %write('moveValue: '), write(MoveValue), write(' current Value: '), write(Value), nl,
        bestMove(GameState, Player, T, H, FinalMove, MoveValue, FinalValue).

bestMove(GameState, Player, [_ | T], Move, FinalMove, Value, FinalValue):-
        %write('not larger'), nl,
        bestMove(GameState, Player, T, Move, FinalMove, Value, FinalValue).

evaluateMove(GameState, Player, Move, MoveValue):-
        Move = [[Ci, Ri], [Cf, Rf]],
        getCell(GameState, Ci, Ri, StartCell),
        getCell(GameState, Cf, Rf, EndCell),
        %print(StartCell), write(' to '), print(EndCell), nl,
        updatePoints(Player, StartCell, EndCell, [[_, MoveValue], _]).
