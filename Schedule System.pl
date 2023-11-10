ta_slot_assignment([],[],_).
ta_slot_assignment([ta(Name,Load)|T],[ta(Name,R)|T],Name):-
    Load > 0,
    R is Load - 1.
ta_slot_assignment([ta(Name,Load)|T],[ta(Name,Load)|T1],Name2):-
    Name\=Name2,
    ta_slot_assignment(T,T1,Name2).

slot_assignment(0,X,X,[]).
slot_assignment(LabsNum,TAs,RemTAs,[Name|T]):-
    LabsNum>0,
    NewLabsNum is LabsNum-1,
    slot_assignment(NewLabsNum,TAs,NewRemTAs,T),
    chooserandom(ta(Name,_),NewRemTAs),
    checkDup(Name,T),
    ta_slot_assignment(NewRemTAs,RemTAs,Name).

chooserandom(H,[H|_]).
chooserandom(X,[_|T]):-
    chooserandom(X,T).

checkDup(_,[]).
checkDup(X,[H|T]):-
    X\=H,
    checkDup(X,T).

max_slots_per_day(DaySched,Max):-
    list1d(DaySched,F),
    checkCount(F,Max).

list1d([],[]).
list1d([[H|T1]|T],[H|Acc]):-
    list1d([T1|T],Acc).
list1d([[]|T],Acc):-
    list1d(T,Acc).

checkCount([],_).
checkCount([H|T],Max):-
	count([H|T],H,C,Acc),
	C=<Max,
	checkCount(Acc,Max).
count([],_,0,[]).
count([H|T],H,C,L):- 
	count(T,H,C1,L), 
	C is 1+C1.
count([H1|T],H2,C,[H1|T1]):-
	H1\=H2,
	count(T,H2,C,T1).

day_schedule([],X,X,[]).
day_schedule([H|T],TAs,RemTAs,[X|T1]):-
	day_schedule(T,TAs,RemTAs1,T1),
	slot_assignment(H,RemTAs1,RemTAs,X).

week_schedule([],_,_,[]).
week_schedule([W|Ws],TAs,DayMax,[X|Xs]):-
	day_schedule(W,TAs,R,X),
	max_slots_per_day(X,DayMax),
    week_schedule(Ws,R,DayMax,Xs).
