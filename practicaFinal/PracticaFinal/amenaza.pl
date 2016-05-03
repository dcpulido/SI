
concatena([], Cs, Cs).
concatena([A|As],Bs,[A|Cs]):-
          concatena(As, Bs, Cs).	


qfor(Y,Y,L,R):- mirafila(Y,Y,L,R,Y).

qfor(X,Y,L,K):-	X1 is X+1 ,
						concatena(MF,R,K),
						mirafila(X,Y,L,MF,Y) ,
						qfor(X1,Y,L,R).

qfor2(Y,Y,LQ,LB,R):- mirafila(Y,Y,LQ,R,Y).

qfor2(X,Y,LQ,LB,K):-	X1 is X+1 ,
						concatena(MF,R,K),
						mirafila(X,Y,LQ,MF,Y) ,
						qfor2(X1,Y,LQ,LB,R).


mirafila(X,0,L,[],S):-	ataca([X,0],L,S).
mirafila(X,0,_,[[X,0]],_).
mirafila(X,Y,L,MF,S):-	Y1 is Y-1 ,
						ataca([X,Y],L,S) ,
						mirafila(X,Y1,L,MF,S).
mirafila(X,Y,L,[[X,Y]|MF],S):-	Y1 is Y-1 ,
								mirafila(X,Y1,L,MF,S).

ataca([],[],_).
ataca([X,_],[[X,_]|_],_).
ataca([_,Y],[[_,Y]|_],_).

ataca(Q,[Car|Cdr],P):-	ataca(Q,Cdr,P)|
						atacaDiag(Q,P,[Car|Cdr]).

atacaDiag([X1,X2],P,[[C1,C2]|R]):-	comprueba(X1,X2,P,[[C1,C2]|R]);
								    nextlvl([X1,X2],P,[[C1,C2]|R]).

nextlvl([X1,X2],P,[[C1,C2]|R]):-P>0 ,
								P1 is P-1 , 
								atacaDiag([X1,X2],P1,[[C1,C2]|R]).



comprueba(X1,X2,P,[[C1,C2]|R]):-comprueba1(X1,X2,P,C1,C2);
						  		comprueba2(X1,X2,P,C1,C2);
						  		comprueba3(X1,X2,P,C1,C2);
			   			  		comprueba4(X1,X2,P,C1,C2);
						  		comprueba5(X1,X2,P,C1,C2);
						  		comprueba(X1,X2,P,R).


comprueba1(X1,X2,P,C1,C2):-	X1 is C1+P , X2 is C2+P.
comprueba2(X1,X2,P,C1,C2):-	X1 is C1-P , X2 is C2+P.
comprueba3(X1,X2,P,C1,C2):-	X1 is C1+P , X2 is C2-P.
comprueba4(X1,X2,P,C1,C2):-	X1 is C1-P , X2 is C2-P.
comprueba5(X1,X2,_,C1,C2):-	X1 is C1 , X2 is C2.				
