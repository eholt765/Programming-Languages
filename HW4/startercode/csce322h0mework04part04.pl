decisionAdjacent(Maze) :-
    checkAdjPoint(Maze),
    !.

getLen([],0) :- !.
getLen([_|T],L) :- 
    !,
    getLen(T,L1), 
    L is L1+1.

getCols([], 0) :- !.
getCols([H|_],Cols) :-
    !,
    getLen(H,Cols).

getRows([],0) :- !.
getRows(Maze,Rows) :-
    !,
    getCols(Maze,C),
    flatten(Maze, FMaze),
    getLen(FMaze, L),
    Rows is L/C.

flatten([], []) :- !.
flatten([H|T], FlatL) :-
    !,
    flatten(H, Rec1),
    flatten(T, Rec2),
    append(Rec1, Rec2, FlatL).
flatten(L, [L]).

elemAtI([E|_],0,E) :- !.
elemAtI([_|T],I,E) :-
    I > 0,
    I1 is I-1,
    elemAtI(T,I1,E).

% member(Item,List)
member(Item,[Item|_]):-!.
member(Item,[_|T]):-
    member(Item,T).

getTopAndBottom(Maze):-
	getRows(Maze, R),
	elemAtI(Maze, 0, X),
	elemAtI(Maze, (R-1), Y),
	append(Y, X, NewList),
    flatten(NewList, FinalList),
    member(-,FinalList),
	!.
	
% getAdjacent(Location,AdjacentLocation)
getAdjacent((R,C),(U,C)):-
    U is R - 1.
getAdjacent((R,C),(D,C)):-
    D is R + 1.
getAdjacent((R,C),(R,L)):-
    L is C - 1.
getAdjacent((R,C),(R,Ri)):-
    Ri is C + 1.
genVal(Value):-
    length(_,Val),
    valGen(Val,Value).
valGen(Value,Value).
valGen(V,Value):-
    Value is V * -1.
nonNeg(Value):-
    length(_,Value).	

adjList((R,C),[(PX1,PY1),(PX2,PY2),(PX3,PY3),(PX4,PY4)]):-
    PX1 is (R-1),
    PX2 is (R+1),
    PX3 is (R),
    PX4 is (R),
    PY1 is (C),
    PY2 is (C),
    PY3 is (C-1),
    PY4 is (C+1),
	!.

% find2D(What,ListOfLists,Where)
find2D(What,[Row|_],(0,Column)):-
    find(What,Row,Column).
find2D(What,[_|Rows],(R,C)):-
    find2D(What,Rows,(RowsR,C)),
    R is RowsR + 1,
    !.
% find(What,List,Where)
find(What,[What|_],0).
find(What,[_|T],Where):-
    find(What,T,WhereT),
    Where is WhereT + 1.

addToList(X,List,NewList):-
    flatten([List|X],NewList).

checkTopEdge(Maze, (X,Y)):-
    elemAtI(Maze, 0, R0),
    flatten(R0, List),
    find(-,List,Loc),
    X is Loc,
    Y is 0,
    !.

checkBottomEdge(Maze, (X,Y)):-
    getRows(Maze, R),
    getCols(Maze, C),
	elemAtI(Maze, (R-1), RL),
    flatten(RL, List),
    find(-,List,Loc),
    getLen(List,Len),
    Diff is Len - Loc,
    X is C - Diff,
    Y is R-1,
    !.
    
getLeftRow(L, List, N, I, R) :-
    N1 is I * N,
    I1 is I + 1,
    Loc is N1,
    elemAtI(L, Loc, Elem), 
    addToList(Elem, List, NewList),
    getLen(L, Len),
    Loc2 is Loc + 1,
    Len2 is Len - N,
    ((Loc2 < Len2 ) ->  getLeftRow(L,NewList, N, I1, R) ; R = NewList).

getLeft(Maze, LC):-
    getCols(Maze, C),
	flatten(Maze, List),
    getLeftRow(List,[], C, 0, LC). 

getRightRow(L, List, N, I, R) :-
    N > 0,
    N1 is N - 1,
    I1 is I + 1,
    Loc is N1 * I1,
    Loc2 is Loc + I,
    elemAtI(L, Loc2, Elem), 
    addToList(Elem, List, NewList),
    getLen(L, Len),
    Loc3 is Loc2 + 1,
    ((Loc3 < Len ) ->  getRightRow(L,NewList, N, I1, R) ; R = NewList).
        
getRight(Maze, LC):-
    getCols(Maze, C),
	flatten(Maze, List),
    getRightRow(List,[], C, 0, LC).

getLeftCord(Maze, (X,Y)):-
    getLeft(Maze, LC),
    find(-,LC,I),
    Y is I,
    X is 0,
    !.

getRightCord(Maze, (X,Y)):-
    getRight(Maze, LC),
    getCols(Maze, C),
    find(-,LC,I),
    Y is I,
    X is C-1,
    !.
    

findExitCord(Maze, (Xe,Ye)):-
    (getLeftCord(Maze,(X,Y)) -> (Xe is X, Ye is Y) ;  
    (getRightCord(Maze,(X,Y)) -> (Xe is X, Ye is Y) ;  
    (checkBottomEdge(Maze,(X,Y))) -> (Xe is X, Ye is Y) ;  
    checkTopEdge(Maze,(X,Y)))),
    Xe is X, 
    Ye is Y,
    !.

checkEqual(A,B):-
	A =:= B.

compareFive(A,B,C,D,E):-
    A == B,
    A == C,
    A == D,
    A == E.

notOpenSpace(A, Count):-
    (A == x ->  Count is 1 ; Count is 0),
    !.
 
check(Count):-
    Count >= 2,
    !.

findExitType(Maze, Type):-
    findExitCord(Maze, (X,Y)),
    getCols(Maze, C),
    getRows(Maze, R),
    C1 is C-1,
    R1 is R-1,
    (checkEqual(X,0) ->  (XC is 1) ; (checkEqual(X,C1) ->  (XC is 2) ; (XC is 3))),
    (checkEqual(Y,0) ->  (YC is 1) ; (checkEqual(Y,R1) ->  (YC is 2) ; (YC is 3))),
    ((((((((checkEqual(XC,3),checkEqual(YC,1)) ->  Type is 1);
    ((checkEqual(XC,3),checkEqual(YC,2)) ->  Type is 2));
    ((checkEqual(XC,1),checkEqual(YC,3)) ->  Type is 3)));
    ((checkEqual(XC,2),checkEqual(YC,3)) ->  Type is 4)))),
    !.              
                 
checkAdjPoint(Maze):-
	findExitType(Maze, T),
    getCols(Maze,C),
%    getRows(Maze,R),
%    print(C),
%    print(R),
	findExitCord(Maze, (Xe,Ye)),
    
	((((((((checkEqual(T,1)) ->  XA is Xe, YA is Ye+1);
    ((checkEqual(T,2)) -> XA is Xe, YA is Ye-1 ));
    ((checkEqual(T,3)) -> XA is Xe+1, YA is Ye)));
    ((checkEqual(T,4)) -> XA is Xe-1, YA is Ye)))),
    PX1 is (XA-1),
    PX2 is (XA+1),
    PX3 is (XA),
    PX4 is (XA),
    PY1 is (YA),
    PY2 is (YA),
    PY3 is (YA-1),
    PY4 is (YA+1),
    
    
    Loc1 is (((PY1 * (C)) + PX1)),
    Loc2 is (((PY2 * (C)) + PX2)),
    Loc3 is (((PY3 * (C)) + PX3)),
    Loc4 is (((PY4 * (C)) + PX4)),
    Loc5 is (((YA * (C)) + XA)),
    

    
    flatten(Maze,FMaze),
    find(E1,FMaze,(Loc1)),
    find(E2,FMaze,(Loc2)),
    find(E3,FMaze,(Loc3)),
    find(E4,FMaze,(Loc4)),
    find(E5,FMaze,(Loc5)),
    

    
    notOpenSpace(E1, C1),
    notOpenSpace(E2, C2),
    notOpenSpace(E3, C3),
    notOpenSpace(E4, C4),
    notOpenSpace(E5, C5),
    
    Count is C1 + C2 + C3 + C4 + C5,
    not(check(Count)),
    !.