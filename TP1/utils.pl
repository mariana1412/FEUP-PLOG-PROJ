%get cell content from GameState
getCell(GameState, CellCol, CellRow, Cell):-
        nth0(CellRow, GameState, Row),
        nth0(CellCol, Row, Cell).

%get size of Board
sizeBoard(GameState, NoCol, NoRow):-
        length(GameState, NoRow),
        nth0(0, GameState, Row),
        length(Row, NoCol).

%creates a new cell according to the move
updateCell([SC, SP, SS], [_EC, EP, ES], [NC, NP, NS]):-
        NC = SC,
        NP is (SP + EP),
        NS is (SS + ES).

%updates Cell, makes the StartCell empty, replaces EndCell content with the NewCell content
updateBoardGame(StartCell, StartCol, StartRow, EndCell, EndCol, EndRow, GameState, NewState):-
        updateCell(StartCell, EndCell, NewCell),
        updateBoard(GameState, StartCol, StartRow, [0, 0, 0], AuxState), %remove StartCell
        updateBoard(AuxState, EndCol, EndRow, NewCell, NewState). %add new values to the EndCell

%makes sure that the index of first row/column is 0, updates Board
updateBoard(GameState, Col, Row, Cell, NewState):- updateRow(GameState, Col, Row, Cell, NewState).

%when it is in the right row, it updates column; otherwise, updates row
updateRow([H|T], Col, 0, Cell, [NH|T]) :- updateColumn(H, Col, Cell, NH).
updateRow([H|T], Col, Row, Cell, [H|NT]) :-
        Row1 is (Row-1),
        updateRow(T, Col, Row1, Cell, NT).

%when it is in the right column, replace it with the new cell; otherwise, updates column
updateColumn([_H|T], 0, Cell, [Cell|T]).
updateColumn([H|T], Col, Cell, [H|NT]) :- 
        Col1 is (Col-1),
        updateColumn(T, Col1, Cell, NT).

%is Empty, when first element is 0
isEmpty([0, _, _]).

%changes order of sublists
changePlayer([[Color, Points], [Color1, Points1]], Player) :- Player = [[Color1, Points1], [Color, Points]].

%update Player points
updatePoints(Player, [X|_], [X|_], Player). %capturing piece of the same color
updatePoints([[Color, Points], Player], _, [1, 1|_], [[Color, NP], Player]):- NP is (Points + 1). %capturing green piece
updatePoints([[Color, Points], [Color1, Points1]], [X|_], [Y, Add|_], [[Color, NP], [Color1, NP1]]):- %capturing enemy piece, update both sublists
            X\=Y, Y\=1,
            NP is (Points + Add),
            NP1 is (Points1 - Add).

getColRowbyIndex(Index, Col, Row, MaxCol):-
        Col is (Index mod MaxCol),
        Row is (Index//MaxCol).

deleteOne(X, L, L1):- append(La, [X|Lb], L), append(La, Lb, L1). 

deleteEmptyList(L1, L2) :- L2 = L1, \+member([], L1).
deleteEmptyList(L1, L2) :- 
        deleteOne([], L1, L),
        deleteEmptyList(L, L2). 

addMove([], ListOfMoves, _, _, NewListOfMoves):-
        append(ListOfMoves, [], NewListOfMoves).

addMove(CleanFinal, ListOfMoves, CurrentCol, CurrentRow, NewListOfMoves):-
        append([[CurrentCol, CurrentRow]], CleanFinal, NewMove),
        append(ListOfMoves, [NewMove], NewListOfMoves).

checkDownCell(Cell, _, Row, CurrentRow, _, _):-
        isEmpty(Cell),
        Row is (CurrentRow+1).
checkDownCell(_, MaxRow, Row, CurrentRow, CurrentCol, MoveDown):-
        NewMove = [[CurrentCol, CurrentRow]],
        append([], NewMove, MoveDown),
        Row is MaxRow.

checkUpCell(Cell, Row, CurrentRow, _, _):-
        isEmpty(Cell),
        Row is (CurrentRow-1).
checkUpCell(_, Row, CurrentRow, CurrentCol, MoveUp):-
        NewMove = [[CurrentCol, CurrentRow]],
        append([], NewMove, MoveUp),
        Row is -1.

checkLeftCell(Cell, Col, CurrentCol, _, _):-
        isEmpty(Cell),
        Col is (CurrentCol-1).
checkLeftCell(_, Col, CurrentCol, CurrentRow, MoveLeft):-
        NewMove = [[CurrentCol, CurrentRow]],
        append([], NewMove, MoveLeft),
        Col is -1.

checkRightCell(Cell, _, Col, CurrentCol, _, _):-
        isEmpty(Cell),
        Col is (CurrentCol+1).
checkRightCell(_, MaxCol, Col, CurrentCol, CurrentRow, MoveRight):-
        NewMove = [[CurrentCol, CurrentRow]],
        append([], NewMove, MoveRight),
        Col is MaxCol.

append4Lists(List1, List2, List3, List4, Final):-
        append([], List1, Final1),
        append(Final1, List2, Final2),
        append(Final2, List3, Final3),
        append(Final3, List4, Final).

noPlayerPiecesRow(Row, 0):- \+ member([2|_], Row).
noPlayerPiecesRow(Row, 1):- \+ member([3|_], Row).
noPlayerPieces([], _).
noPlayerPieces([H|T], Player):- noPlayerPiecesRow(H, Player), noPlayerPieces(T, Player).

countPointsStack(GameState, BlackPoints, BlackHighestStack, WhitePoints, WhiteHighestStack) :-
        sizeBoard(GameState, MaxCol, MaxRow),
        getPlayerPieces(GameState, 0, _BlackP, BlackPieces, _WhiteP, WhitePieces, MaxCol, MaxRow),
        processPlayerPieces(BlackPieces, 0, 0, BlackPoints, BlackHighestStack),
        processPlayerPieces(WhitePieces, 0, 0, WhitePoints, WhiteHighestStack).       

getPlayerPieces(_, Index, BlackP, BlackPieces, WhiteP, WhitePieces, MaxCol, MaxRow) :-
        Index is (MaxCol*MaxRow),
        deleteEmptyList(BlackP, Black),
        BlackPieces = Black,
        deleteEmptyList(WhiteP, White),
        WhitePieces = White.

getPlayerPieces(GameState, Index, BlackP, BlackPieces, WhiteP, WhitePieces, MaxCol, MaxRow) :-
        getColRowbyIndex(Index, CurrentCol, CurrentRow, MaxCol),
        getCell(GameState, CurrentCol, CurrentRow, Cell),
        processCell(Cell, BP, WP),
        append(BlackP, [BP], Black),
        append(WhiteP, [WP], White),
        NextIndex is (Index+1),
        getPlayerPieces(GameState, NextIndex, Black, BlackPieces, White, WhitePieces, MaxCol, MaxRow). 

processCell(Cell, BlackP, WhiteP):- Cell = [2|_], BlackP = Cell, WhiteP = [].
processCell(Cell, BlackP, WhiteP):- Cell = [3|_], WhiteP = Cell, BlackP = [].
processCell(_, [], []).

processPlayerPieces([], 0, 0, 0, 0).
processPlayerPieces([], P, S, Points, Stack):- Points = P, Stack = S.
processPlayerPieces([H|T], P, S, Points, Stack):-
        H = [_, CP, CS],
        FinalPoints is (P + CP),
        compareStack(S, CS, FinalStack),
        processPlayerPieces(T, FinalPoints, FinalStack, Points, Stack).

compareStack(HighestStack, Stack, FinalStack):- Stack > HighestStack, FinalStack = Stack.
compareStack(HighestStack, _, HighestStack).