:- dynamic location/3.

map_size(5, 5).

location(couch, 2, 0).
location(tv, 2, 4).
location(fcoffee_table, 2, 2).
location(lamp, 4, 4).
location(door, 4, 0).

next_to(A, B) :-
    location(A, X1, Y1),
    location(B, X2, Y2),
    abs(X1-X2) + abs(Y1-Y2) =:= 1.

between(A, B, C) :-
    ( location(A, X, Y), location(B, X, Y1), location(C, X, Y2), Y1 < Y, Y < Y2 ); 
    ( location(A, X, Y), location(B, X1, Y), location(C, X2, Y), X1 < X, X < X2 ).

place(Object, X, Y) :-
    \+ location(_, X, Y), assertz(location(Object, X, Y)).

remove(Object) :-
    (location(Object, _, _) -> retract(location(Object, _, _))).

leave :-
    location(@, X, Y),
    (next_to(@, door) -> halt; write('You have to be next to the door'), nl).

%----------------------------MOVEMENT---------------------------

direction(up, X, Y, X1, Y) :- X1 is X - 1.
direction(down, X, Y, X1, Y) :- X1 is X + 1.
direction(left, X, Y, X, Y1) :- Y1 is Y - 1.
direction(right, X, Y, X, Y1) :- Y1 is Y + 1.

move(Directions) :-
    location(@, X, Y),
    move(Directions, X, Y, FinalX, FinalY),
    remove(@),
    place(@, FinalX, FinalY),
    draw_map.

move([], X, Y, X, Y).
move([Direction|Rest], X, Y, FinalX, FinalY) :-
    direction(Direction, X, Y, X1, Y1),
    valid_move(X1, Y1),
    (location(_, X1, Y1) -> FinalX = X1, FinalY = Y1;
    move(Rest, X1, Y1, FinalX, FinalY)).

valid_move(X, Y) :-
    map_size(MaxX, MaxY),
    X >= 0, X < MaxX,
    Y >= 0, Y < MaxY,
    \+ location(_, X, Y).

%-----------------------------MAP DRAWING------------------------------

get_map(Map) :-
    map_size(MaxX, MaxY),
    get_map(0, MaxX, MaxY, Map).

get_map(X, X, _, []) :- !.

get_map(X, MaxX, MaxY, [Row | Rest]) :-
    get_row(X, 0, MaxY, Row),
    NextX is X + 1,
    get_map(NextX, MaxX, MaxY, Rest).

get_row(_, Y, Y, []) :- !.
get_row(X, Y, MaxY, [Tile | Rest]) :-
    (location(Object, X, Y) -> atom_chars(Object, [FirstLetter | _]), Tile = FirstLetter ; Tile = '-'),
    NextY is Y + 1,
    get_row(X, NextY, MaxY, Rest).

draw_map :-
    get_map(Map),
    draw_map(Map).

draw_map([]) :- !.
draw_map([Row | Rest]) :-
    draw_row(Row),
    draw_map(Rest).

draw_row([]) :-
    nl.
draw_row([Tile | Rest]) :-
    write(Tile),
    write('	'),
    draw_row(Rest).

%---------------------------HELP-------------------------------
help :-
    writeln('Documentation for available procedures:'), nl,
    writeln('next_to(A, B). - Checks if object A is adjacent to object B on the map.'), nl,
    writeln('between(A, B, C). - Checks if object A is between objects B and C on the map.'), nl,
    writeln('place(Object, X, Y). - Places an object at the specified coordinates (X, Y) on the map.'), nl,
    writeln('remove(Object). - Removes an object from the map.'), nl,
    writeln('leave. - Checks if the player is next to the door and exits the program if true.'), nl,
    writeln('direction(Direction, X, Y, X1, Y1). - Computes the new coordinates (X1, Y1) based on the current coordinates (X, Y) and the given direction.'), nl,
    writeln('move(Directions). - Moves the player along the specified directions, updating their position on the map.'), nl,
    writeln('valid_move(X, Y). - Checks if the specified coordinates (X, Y) are a valid move on the map.'), nl,
    writeln('get_map(Map). - Retrieves the current map as a list of lists.'), nl,
    writeln('draw_map. - Draws the current map on the console.'), nl,
    writeln('help. - Displays the available procedures and their documentation.').