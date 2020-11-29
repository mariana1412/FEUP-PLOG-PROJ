%reads column and validates it
readColumn(Column, NoCol):- 
        write('Column: '), get_char(C),
        C \= '\n', peek_char(Y), skip_line, Y == '\n',
        column(C, Col), Col \= -1, Col < NoCol, Column = Col.
readColumn(Column, NoCol):- write('Column is invalid. Try again!\n'), readColumn(Column, NoCol).

%reads row and validates it
readRow(Row, NoRow):- 
        write('Row: '), get_char(R),
        R \= '\n', peek_char(Y), skip_line, Y == '\n',
        row(R, RAux), RAux \= -1, RAux < NoRow, Row = RAux.
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
        get_char(Option), Option \= '\n', peek_char(Y), skip_line, Y == '\n',
        checkOption(Option, ValidMoves, Op),
        nth1(Op, ValidMoves, Move),
        Move = [[_,_], [Column, Row]]. 

checkOption(Option, ValidMoves, Op):-
        length(ValidMoves, NoCell),
        option(Option, Op),
        Op > 0, Op =< NoCell.

%reads end cell with error handling
readEnd(Cell, Column, Row, GameState, ValidMoves):- 
        write('Where are you moving it to? Insert the number of the chosen cell: '),
        readOption(ValidMoves, Column, Row), 
        getCell(GameState, Column, Row, Cell).

readEnd(Cell, Column, Row, GameState, ValidMoves):-
        write('Invalid input. '),
        readEnd(Cell, Column, Row, GameState, ValidMoves).

%reads player move making sure it is a possible one
readMove(Player, GameState, StartCell, StartColumn, StartRow, EndCell, EndColumn, EndRow):-
        nl, readStart(StartC, StartCol, StartR, Player, GameState, ValidMoves),
        write('You chose piece '), displayColRow(StartCol, StartR), write('.\n'), displayValidMoves(ValidMoves), nl, !,
        readEnd(EndC, EndCol, EndR, GameState, ValidMoves),
        StartCell = StartC, StartColumn=StartCol, StartRow=StartR,
        EndCell = EndC, EndColumn=EndCol, EndRow=EndR.

checkMenuOption(OpChar, Option):-
        option(OpChar, Option),
        Option > 0, Option =< 4.

readMenuOption(Option):-
        get_char(OpChar), OpChar \= '\n', peek_char(Y), skip_line, Y == '\n',
        checkMenuOption(OpChar, Option).

getPlayerOptions(Player):-
        nl, displayMenu,
        readMenuOption(Option),
        getPlayerFromOption(Option, Player).

getPlayerOptions(Player):-
        write('\nInvalid Input.'), nl,
        getPlayerOptions(Player).

getPlayerFromOption(1, [[0, 0, 0], [1, 0, 0]]).

getPlayerFromOption(2, Player):-
        getLevelOption(2, Level), nl,
        Player = [[0, 0, 0], [1, 0, Level]].

getPlayerFromOption(3, Player):-
        getLevelOption(1, Level), nl,
        Player = [[0, 0, Level], [1, 0, 0]].

getPlayerFromOption(4, Player):-
        getLevelOption(1, Level1), nl,
        getLevelOption(2, Level2), nl,
        Player = [[0, 0, Level1], [1, 0, Level2]].

getLevelOption(Player, Level):-
        write('What is the level of Player '), write(Player), write('?  1.Random | 2.Smart'), nl,
        get_char(Option), Option \= '\n', peek_char(Y), skip_line, Y == '\n',
        option(Option, Level),
        Level > 0, Level < 3.

getLevelOption(Player, Level):-
        write('\nInvalid Input.'), nl,
        getLevelOption(Player, Level).

getInitialGameState(GameState):-
        displayBoardSizes,
        get_char(OpChar), OpChar \= '\n', peek_char(Y), skip_line, Y == '\n',
        option(OpChar, Option),
        Option > 0, Option < 4,
        initBoard(GameState, Option).

getInitialGameState(GameState):-
        write('\nInvalid Input.'), nl,
        getInitialGameState(GameState).