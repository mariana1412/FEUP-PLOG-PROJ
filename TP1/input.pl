%letter(1, 'A').
%letter(2, 'B').
%letter(3, 'C').
%letter(4, 'D').
%letter(5, 'E').
%letter(6, 'F').


%getCell(Column, Row) :- write('Column: '), get_char(C), nl, write('Row: '), get_char(Row), letter(Collumn, C).

%getStart(Column, Row) :- write('Which piece are you gonna move?'), nl, getCell(Column, Row).

%getEnd(Column, Row) :- write('Where are you moving it to?'), nl, getCell(Column, Row).

%getMove(ColumnS, RowS, ColumnE, RowE) :- getStart(ColumnS, RowS), nl, getEnd(ColumnE, RowE)).