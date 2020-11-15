%reads column and validates it
readColumn(Column):- write('Column: '), get_char(C), get_char(_), validateColumn(C, Column).

%reads row and validates it
readRow(Row):- write('Row: '), get_char(R), get_char(_), validateRow(R, Row).

%reads cell 
readCell(Column, Row):- nl, readColumn(Column), readRow(Row), nl.

%reads start cell with error handling
readStart(Cell, Column, Row, Player, GameState):- 
        write('Which piece are you gonna move?'),
        readCell(C, R), !,
        getCell(GameState, C, R, NewCell), !,
        (
            (
                validateStart(NewCell, Player), !,
                Cell=NewCell,
                Column=C,
                Row=R
            );
            (
                write('You can\'t move that piece. Try again!\n'),
                readStart(Cell, Column, Row, Player, GameState)
            )
        ).

%reads end cell with error handling
readEnd(Cell, Column, Row, GameState):- 
        write('Where are you moving it to?'),
        readCell(Column, Row),
        getCell(GameState, Column, Row, Cell), !,
        validateEnd(Cell).

%reads player move making sure it is a possible one
readMove(Player, GameState, StartCell, StartColumn, StartRow, EndCell, EndColumn, EndRow):-
        nl, readStart(StartC, StartCol, StartR, Player, GameState), !, 
        readEnd(EndC, EndCol, EndR, GameState), !,
        validateMove(StartCol, StartR, EndCol, EndR, GameState), !,
        StartCell=StartC, StartColumn=StartCol, StartRow=StartR,
        EndCell=EndC, EndColumn=EndCol, EndRow=EndR.

%column must be between A-F
validateColumn('A', 1).
validateColumn('B', 2).
validateColumn('C', 3).
validateColumn('D', 4).
validateColumn('E', 5).
validateColumn('F', 6).
validateColumn(_, Column):- write('Column is invalid. Try again!\n'), readColumn(Column). 

%row must be between 1-6
validateRow('1', 1).
validateRow('2', 2).
validateRow('3', 3).
validateRow('4', 4).
validateRow('5', 5).
validateRow('6', 6).
validateRow(_, Row):- write('Row is invalid. Try again!\n'), readRow(Row). 
