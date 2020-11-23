choose_move(GameState, Player, 1, Move):-
        valid_moves(GameState, Player, ListOfMoves),
        length(ListOfMoves, Len),
        random(0, Len, MoveNumber),
        nth0(MoveNumber, ListOfMoves, Move).

choose_move(GameState, Player, 2, Move):-
        value(GameState, Player, Move).

value(GameState, Player, Value):-
        valid_moves(GameState, Player, ListOfMoves),
        bestMove(GameState, Player, ListOfMoves, [], Value, [-1, -2], _).

bestMove(_, _, [], Move, FinalMove, Value, FinalValue):- FinalValue = Value, FinalMove = Move.

bestMove(GameState, Player, [H | T], Move, FinalMove, Value, FinalValue):-
        %write('evaluating: '), print(H), nl,
        evaluateMove(GameState, Player, H, MoveValue),
        compareValue(MoveValue, Value, H, Move, CurrentMove, CurrentValue),
        %write('moveValue: '), print(MoveValue), write(' current Value: '), print(Value), nl,
        bestMove(GameState, Player, T, CurrentMove, FinalMove, CurrentValue, FinalValue).

evaluateMove(GameState, [[_, P1Points, _], [_, P2Points, _]], Move, MoveValue):-
        Move = [[Ci, Ri], [Cf, Rf]],
        getCell(GameState, Ci, Ri, StartCell),
        getCell(GameState, Cf, Rf, EndCell),
        %print(StartCell), write(' to '), print(EndCell), nl,
        updatePoints([[_, P1Points, _], [_, P2Points, _]], StartCell, EndCell, [[_, NewP1Points, _], [_, NewP2Points, _]]),
        P1PointDiff is (NewP1Points-P1Points),
        P2PointDiff is (NewP2Points-P2Points),
        %write('Calculation: '), write(P1PointDiff), write(' and '), write(P2PointDiff), nl,
        calculateValue(P1PointDiff, P2PointDiff, StartCell, EndCell, MoveValue).

calculateValue(0, 0, [X | _], [X | _], Value):-
        Value = [0, -1].

calculateValue(0, 0, _, _, Value):-
        Value = [0, 1].

calculateValue(1, 0, _, _, Value):-
        Value = [1, 0].

calculateValue(V, _, _, _, Value):-
        Value = [V, 1].

compareValue([Vi, Ei], [Cv, _], Move, _, FinalMove, FinalValue):-
        Vi > Cv,
        FinalMove = Move,
        FinalValue = [Vi, Ei].

compareValue([Vi, _], [Cv, Ce], _, CurrentMove, FinalMove, FinalValue):-
        Vi < Cv,
        FinalMove = CurrentMove,
        FinalValue = [Cv, Ce].

compareValue([Vi, Ei], [_, Ce], Move, _, FinalMove, FinalValue):-
        Ei > Ce,
        FinalMove = Move,
        FinalValue = [Vi, Ei].

compareValue([Vi, Ei], [Cv, Ce], Move, CurrentMove, FinalMove, FinalValue):-
        randomChange([Vi, Ei], [Cv, Ce], Move, CurrentMove, FinalMove, FinalValue).

randomChange(_, [Cv, Ce], _, CurrentMove, FinalMove, FinalValue):-
        random(0, 2, 0),
        FinalMove = CurrentMove,
        FinalValue = [Cv, Ce].

randomChange([Vi, Ei], _, Move, _, FinalMove, FinalValue):-
        FinalMove = Move,
        FinalValue = [Vi, Ei].