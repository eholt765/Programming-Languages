fewestDecisions(Maze,Moves):-
	test(Maze,Moves),
	!.


:-dynamic(edge/2).



getAllOpens(Maze, Opens):-
	findall(Where, (find2D(-, Maze, Where)), Opens),
    !.


reverseCords((X,Y),(A,B)):-
    %reversed to swap to correct order
    A is Y, %is now real X
    B is X. %is now real Y

createEdges([H|T],List) :-
    buildEdges(H,List),
    createEdges(T,List),
    !.

createEdges([H|_],List):-
    buildEdges(H,List),
    !.

buildEdges(H,List):-
    getAdjacentU(H,U),
    getAdjacentD(H,D),
    getAdjacentL(H,L),
    getAdjacentR(H,R),
    (member(U,List) ->  asserta(edge(H,U)), asserta(edge(U,H)) ; true),
    (member(D,List) ->  asserta(edge(H,D)), asserta(edge(D,H)) ; true),
    (member(L,List) ->  asserta(edge(H,L)), asserta(edge(L,H)) ; true),
    (member(R,List) ->  asserta(edge(H,R)), asserta(edge(R,H)) ; true),
    !.

connectPlayer(P,List):-
    %reverseCords(PL,P),
    %print(P),
    getAdjacentU(P,U),
    getAdjacentD(P,D),
    getAdjacentL(P,L),
    getAdjacentR(P,R),
    (member(U,List) ->  asserta(edge(P,U)), asserta(edge(U,P)) ; true),
    (member(D,List) ->  asserta(edge(P,D)), asserta(edge(D,P)) ; true),
    (member(L,List) ->  asserta(edge(P,L)), asserta(edge(L,P)) ; true),
    (member(R,List) ->  asserta(edge(P,R)), asserta(edge(R,P)) ; true),
    !.


test(Maze,Moves):-
    getAllOpens(Maze, Opens),
    %print(Opens),
    %(findCheck((1,3),Opens) -> print("A") ; print("B")), 
    %
   	createEdges(Opens,Opens),
    findExitCord(Maze, (XE,YE)),
  
    findPlayer(Maze,(X,Y)),
    connectPlayer((X,Y),Opens),
    get_time(TimeStamp),
    %print(TimeStamp),
    
    
   % print("CHECK 1"),
   % dfsSmart((X,Y),(YE,XE),[],Path2),
    bfs((X,Y),(YE,XE),[],Path,TimeStamp,Error),
    get_time(TimeStampA),
    (   Error == 1 -> dfsSmart((X,Y),(YE,XE),[],Path2,TimeStampA) ; true), 
  
   (   Error == 1 -> repeatsLoop((X,Y),Path2,0,[0],RL);true),
   (   Error == 1 -> last(RL,N2Remove);true), 
    (   Error == 1 -> removeLoop(N2Remove,Path2,RPath);true),
   % print(RPath),
   % print("CHECK 2"),
   (   Error == 0 -> length(Path,L),convertPathtoMoves(L, Path,Maze,[],Moves);
   length(RPath,L),convertPathtoMoves(L, RPath,Maze,[],Moves)), 
    !.


    

findRepeats((X,Y),Path,Repeats):-
    findall(Where, elemAtI(Path,Where,(X,Y)), Repeats),
    !.
	%findall(Where, (find2D(-, Maze, Where)), Opens),
    %!.

removeLoop(I,Path,RPath):-
    (I>0 ->  removehead(Path,NewPath),S is I - 1,removeLoop(S,NewPath,RPath);RPath = Path),
    !.

repeatsLoop((X,Y),Path,I,List,RL):-
    length(Path,L),
    (L > I -> extraStart((X,Y),Path,I,Loc), S is I+1,
        (not(Loc = 0) ->  addToList(Loc,List,NL); NL = List),
        repeatsLoop((X,Y),Path,S,NL,RL)
    ; RL = List),  
    !.

extraStart(S,Path,I,Loc):-
    elemAtI(Path,I,E),
    (S == E ->  Loc is I ; Loc is 0),
    !.

convertPathtoMoves(L, Path,Maze,List,RL):-
    loop(0, L, Path,Maze,List,RL),
    !.

removehead([_|Tail], Tail).

% dfsSmart(From,To,Visited,Path)
dfsSmart(From,From,_,[From],_).
dfsSmart(From,To,Visited,[From|RestOfPath],TS):-
    get_time(TimeStamp3),
    Diff is TimeStamp3 - TS,
  
    (   ( Diff < 4)->  
    edge(From,Next),
    not(member(Next,Visited)),
    dfsSmart(Next,To,[Next|Visited],RestOfPath,TS);!).

loop2(I,List,RL) :- 
    (I > 0 -> S is I-1, addToList(I,List,NL),print(NL),
        loop2(S,NL,RL) ; RL = List),
    !. 
  
loop(I,L,Path,Maze,List,RL) :- 
    ((L-1)>I -> moveType(I,Path,M), 
    dPoint(I,Path,Maze,T), 
    S is I+1,
    ((I == 0 ; T == 1) ->  addToList(M,List,NL) ; NL = List),
    loop(S,L,Path,Maze,NL,RL) 
    ; RL = List),
    !. 


dPoint(I,Path,Maze,T):-
    elemAtI(Path,I,E1),
	isDecsicion(E1,Maze,C),
    (check(C) -> T is 1 ; T is 0 ),
    
	!.
    

getMove(E1,E2, M):-
    getAdjacentU(E1,U),
    getAdjacentD(E1,D),
    getAdjacentL(E1,L),
%    getAdjacentR(E1,R),
    (E2 == U -> M = u ; E2 == D -> M = d ; E2 == L -> M = l ; M = r).
 
notOpenSpace(A, Count):-
    (not(A == x) ->  Count is 1 ; Count is 0),
    !.

isDecsicion(E,Maze,C):-
    getAdjacentU(E,U),
    getAdjacentD(E,D),
    getAdjacentL(E,L),
    getAdjacentR(E,R),
    find2D(EU,Maze,U),
    find2D(ED,Maze,D),
    find2D(ER,Maze,R),
    find2D(EL,Maze,L),
    notOpenSpace(EU,C1),
    notOpenSpace(ED,C2),
    notOpenSpace(ER,C3),
    notOpenSpace(EL,C4),
    C is C1 + C2 + C3 + C4,
    !.
    
check(Count):-
    Count >= 3,
    !.   


moveType(I,Path,M):-
    elemAtI(Path,I,E1),
    elemAtI(Path,(I+1),E2),
    getMove(E1,E2, M),
    !.
    
    
    
% member(Item,List)
member((X,Y),[(X,Y)|_]):-!.
member((X,Y),[_|T]):-
    member((X,Y),T).

% getAdjacent(Location,AdjacentLocation)
getAdjacentU((R,C),(U,C)):-
    U is R - 1.
getAdjacentD((R,C),(D,C)):-
    D is R + 1.
getAdjacentL((R,C),(R,L)):-
    L is C - 1.
getAdjacentR((R,C),(R,Ri)):-
    Ri is C + 1.

% find2D(What,ListOfLists,Where)
find2D(What,[Row|_],(0,Column)):-
    find(What,Row,Column).
find2D(What,[_|Rows],(R,C)):-
    find2D(What,Rows,(RowsR,C)),
    R is RowsR + 1.
% find(What,List,Where)
find(What,[What|_],0).
find(What,[_|T],Where):-
    find(What,T,WhereT),
    Where is WhereT + 1.

% find(What,List,Where)
findCheck(What,[What|_]).
findCheck(What,[_|T]):-
    findCheck(What,T).


% bfs(From,To,Path)
bfs(From,From,_,[From],_,_).
bfs(From,To,Visited,[From|RestOfPath],TS,E):-
    %print(From),
    get_time(TimeStamp2),
    Diff is TimeStamp2 - TS,
   % write(Diff),
   % write(\n),
    %write(nl),
    length(RestOfPath,Len),
    ((   Len < 50 , Diff < 4)->  
    edge(From,Next),
    not(member(Next,Visited)),
    E is 0,
    bfs(Next,To,[Next|Visited],RestOfPath,TS,E) ; E is 1,!
    ).
    

findPlayer(Maze,(X,Y)):-
   find2D(1,Maze,(X,Y)),
   !.  

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



addToList(X,List,NewList):-
    flatten([List|X],NewList).








