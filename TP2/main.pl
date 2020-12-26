operation(0, '+').
operation(1, '-').
operation(2, '*').
operation(3, '/').

%1st example at https://erich-friedman.github.io/puzzle/star/
%operations from top to bottom, left to right (see images/internalRepresentation.png)
example([1, 2, 0, 2, 2, 1, 0, 2, 0, 2]).

%operations from top to bottom, left to right (see images/internalRepresentation.png)
equations(Star, Equations):-
    Star = [O0, O1, O2, O3, O4, O5, O6, O7, O8, O9],
    Equations = [
        [A, O0, C, F],
        [A, O1, D, G],
        [B, O2, C, D],
        [E, O3, D, C],
        [B, O4, F, H],
        [E, O5, G, H],
        [I, O6, F, C],
        [J, O7, G, D],
        [I, O8, H, G],
        [J, O9, H, F]
    ].