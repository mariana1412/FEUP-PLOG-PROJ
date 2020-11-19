%reads column and validates it
readColumn(Column, NoCol):- write('Column: '), get_char(C), get_char(_), column(C, Col), Col \= -1, Col < NoCol, Column = Col.
readColumn(Column, NoCol):- write('Column is invalid. Try again!\n'), readColumn(Column, NoCol).

%reads row and validates it
readRow(Row, NoRow):- write('Row: '), get_char(R), get_char(_), row(R, RAux), RAux \= -1, RAux < NoRow, Row = RAux.
readRow(Row, NoRow):- write('Row is invalid. Try again!\n'), readRow(Row, NoRow).

%reads cell 
readCell(GameState, Column, Row):- nl, sizeBoard(GameState, NoCol, NoRow), readColumn(Column, NoCol), readRow(Row, NoRow), nl.

%reads start cell with error handling
readStart(Cell, Column, Row, Player, GameState, ValidMoves):- 
        write('Which piece are you gonna move?'),
        readCell(GameState, C, R),
        verifyStartCell(GameState, Player, C, R, Cell, Column, Row, ValidMoves).

verifyStartCell(GameState, Player, C, R, Cell, Column, Row, ValidMoves) :- 
        cellValidMoves(GameState, Player, C, R, Moves), Moves \= [],
        getCell(GameState, C, R, Cell), Column=C, Row=R, ValidMoves=Moves.

verifyStartCell(GameState, Player, _, _, Cell, Column, Row, ValidMoves):-
        write('You can\'t move that piece. Try again!\n'),
        readStart(Cell, Column, Row, Player, GameState, ValidMoves).

readOption(ValidMoves, Column, Row):-
        get_char(Option), get_char(_),
        checkOption(Option, ValidMoves, Op),
        nth1(Op, ValidMoves, Move),
        Move = [[_,_], [Column, Row]]. 

checkOption(Option, ValidMoves, Op):-
        length(ValidMoves, NoCell),
        option(Option, Op),
        Op > 0, Op =< NoCell.

%reads end cell with error handling
readEnd(Cell, Column, Row, GameState, ValidMoves):- 
        displayValidMoves(ValidMoves), nl,
        write('Where are you moving it to? Insert the number of the chosen cell: '),
        readOption(ValidMoves, Column, Row),
        write('Column: '), write(Column), write(' Row: '), write(Row), nl,
        getCell(GameState, Column, Row, Cell).

readEnd(Cell, Column, Row, GameState, ValidMoves):-
        write('\nInvalid input. '),
        readEnd(Cell, Column, Row, GameState, ValidMoves).

%reads player move making sure it is a possible one
readMove(Player, GameState, StartCell, StartColumn, StartRow, EndCell, EndColumn, EndRow):-
        nl, readStart(StartC, StartCol, StartR, Player, GameState, ValidMoves),
        readEnd(EndC, EndCol, EndR, GameState, ValidMoves),
        StartCell=StartC, StartColumn=StartCol, StartRow=StartR,
        EndCell=EndC, EndColumn=EndCol, EndRow=EndR.

        