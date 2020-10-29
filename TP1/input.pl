%TO DO: se for mais do que um carater, isto passa-se :D 

readColumn(Column):- write('Column: '), get_char(C), get_char(_), validateColumn(C, Column).

readRow(Row):- write('Row: '), get_char(R), get_char(_), validateRow(R, Row).

readCell(Column, Row):- nl, readColumn(Column), readRow(Row), nl.

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

readEnd(Cell, Column, Row, GameState):- 
        write('Where are you moving it to?'),
        readCell(Column, Row),
        getCell(GameState, Column, Row, Cell), !,
        validateEnd(Cell).

readMove(Player, GameState, StartCell, StartColumn, StartRow, EndCell, EndColumn, EndRow):-
        readStart(StartC, StartCol, StartR, Player, GameState), !,
        (
            (   
                readEnd(EndC, EndCol, EndR, GameState), !,
                validateMove(StartCol, StartR, EndCol, EndR, GameState), !,
                StartCell=StartC, StartColumn=StartCol, StartRow=StartR,
                EndCell=EndC, EndColumn=EndCol, EndRow=EndR
            );
            (
                write('Invalid move. Try again!\n'),
                readMove(Player, StartCell, StartCol, StartRow, EndCell, EndCol, EndRow)
            )
        ).

validateColumn('A', 1).
validateColumn('B', 2).
validateColumn('C', 3).
validateColumn('D', 4).
validateColumn('E', 5).
validateColumn('F', 6).
validateColumn(_, Column):- write('Column is invalid. Try again!\n'), readColumn(Column). 

validateRow('1', 1).
validateRow('2', 2).
validateRow('3', 3).
validateRow('4', 4).
validateRow('5', 5).
validateRow('6', 6).
validateRow(_, Row):- write('Row is invalid. Try again!\n'), readRow(Row). 
