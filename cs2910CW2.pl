% coursework2


% Modified code from worksheet 4 of prolog labs
% searching algorithm used is depth-first search.

% representation of floor plan as prolog facts

adjacent(outside,porch1).
adjacent(porch1,kitchen).
adjacent(kitchen,living_room).
adjacent(corridor,bedroom).
adjacent(corridor,wc).
adjacent(corridor,master_bedroom).
adjacent(corridor,living_room).
adjacent(living_room,porch2).
adjacent(porch2,outside).


% representation of floor plan as prolog facts with costs considered
% adding c to exsisting variables as they factor cost into caclualtion
adjacentc(outside,porch1,1).
adjacentc(porch1,kitchen,1).
adjacentc(kitchen,living_room,3).
adjacentc(corridor,bedroom,2).
adjacentc(corridor,wc,2).
adjacentc(corridor,master_bedroom,2).
adjacentc(corridor,living_room,1).
adjacentc(living_room,porch2,5).
adjacentc(porch2,outside,1).


% predicate to check whether two rooms are connected.
connected(X,Y) :- adjacent(X,Y) ; adjacent(Y,X).


find(A,B,P,[B|P]) :-
    connected(A,B).

% recursively calls connected to check whether two rooms are connected.
find(A,B,P,Way) :-
    connected(A,C),
    \+member(C,P),
    B \== C,
    find(C,B,[C|P],Way).

% predicate to check whether two rooms are connected with addition of cost.
connectedc(X,Y,L) :- adjacentc(X,Y,L) ; adjacentc(Y,X,L).


findc(A,B,P,[B|P],L) :-
    connectedc(A,B,L).

% recursively calls connectedc to check whether two rooms are connected.
findc(A,B,P,Way,L) :-
    connectedc(A,C,D),
    \+member(C,P),
    B \== C,
    findc(C,B,[C|P],Way,L1),
    L is D+L1.

% predicate that checks whether room entered is part of a list.
valid_room(Room) :-
    member(Room, [outside, porch1, porch2, kitchen, living_room, corridor, bedroom, wc, master_bedroom]).

    
% calls find and returns a path from origin to destination in the correct order.
pathc(A,B,Path,Len) :-
    valid_room(A),
    valid_room(B),
    findc(A,B,[A],Way,Len),
    reverse(Way,Path).
    
% calls find and returns a path from origin to destination in the correct order.
path(A,B,Path) :-
    valid_room(A),
    valid_room(B),
    find(A,B,[A],Way),
    reverse(Way,Path).
    
% checks if room A is in the floor plan
path(A,B,_) :-
    \+ valid_room(A),
    valid_room(B),
    format('Error: ~w is not a valid room.~n', [A]),
    !,fail.
% checks if room B is in the floor plan    
path(A,B,_) :-
    \+ valid_room(B),
    valid_room(A),
    format('Error: ~w is not a valid room.~n', [B]),
    !,fail.
% checks if room A and B are in the floor plan    
path(A,B,_) :-
    \+ valid_room(B),
    \+valid_room(A),
    format('Error: ~w is not a valid room.~n', [B]),
    format('Error: ~w is not a valid room.~n', [A]),
    !,fail.

    
% Find a bipath from A and B to D
% output format based on piazza question @36. 
bipath(A, B, D, P) :-
    path(A, D, Path1),           % Find a path from A to D
    select(D, Path1, Path1_NoD),  % Remove D from Path1
    path(B, D, Path2),           % Find a path from B to D
    select(D, Path2, Path2_NoD),  % Remove D from Path2
    append(Path1_NoD,[[D]],PathA),  % Combines path1 with destination in square brackets  
    append(PathA,Path2_NoD, P). % Combine PathA and Path2_NoD to create P    
    
% this is the modified code for bipath q3 variation.
% Find a bipath from A and B to D
% output format based on piazza question @36. 
bipathc(A, B, D, P) :-
    pathrank(A, D, Path1, Len1),   % Find the shortest path from A to D
    pathrank(B, D, Path2, Len2),   % Find the shortest path from B to D
    Len1 =:= Len2,                 % Check if both paths have the same length
    select(D, Path1, Path1_NoD),   % Remove D from Path1
    select(D, Path2, Path2_NoD),   % Remove D from Path2
    append(Path1_NoD, [[D]], PathA), % Combine Path1 with destination in square brackets
    append(PathA, Path2_NoD, P).   % Combine PathA and Path2_NoD to create P

% modified version of rank function considering the cost.
% code from ex4 modified.

% outputs path based on length of trip
pathrank(A,B,Path,Length) :-
   setof([P,L],pathc(A,B,P,L),Set),
   Set = [_|_], % requires at least one element i.e. fails if empty
   sort(Set,SortedSet), % sort the set based on length
   member([Path,Length],SortedSet). % output paths with smallest lengths first
