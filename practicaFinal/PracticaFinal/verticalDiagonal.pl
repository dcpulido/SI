qfor(Y,Y,LQ,LB,R):- mirafila(Y,Y,LQ,LB,R,Y).

qfor(X,Y,LQ,LB,K):-	X1 is X+1 ,
						concat(MF,R,K),
						mirafila(X,Y,LQ,LB,MF,Y),
						qfor(X1,Y,LQ,LB,R).
						
concat([], Cs, Cs).
concat([A|As],Bs,[A|Cs]):-
          concat(As, Bs, Cs).

mirafila(X,0,LQ,LB,[],S):-	ataca([X,0],LQ,LB,S).
mirafila(X,0,_,_,[[X,0]],_).
mirafila(X,Y,LQ,LB,MF,S):-	Y1 is Y-1 ,
						ataca([X,Y],LQ,LB,S) ,
						mirafila(X,Y1,LQ,LB,MF,S).
mirafila(X,Y,LQ,LB,[[X,Y]|MF],S):-	Y1 is Y-1 ,
								mirafila(X,Y1,LQ,LB,MF,S).
								
ataca([],[],_,_).
ataca([X,Z],[[X,Y]|R],LB,S):- mayorque(Z,Y,R1),
							menorque(Z,Y,R2),
							not(hayBloqueVertical(X,R2,R1,LB)).
ataca([Z,Y],[[X,Y]|R],LB,S):-mayorque(Z,X,R1),
							menorque(Z,X,R2),
							not(hayBloqueHorizontal(Y,R2,R1,LB)).
ataca([Z,Y],[[A,B]|R],LB,S):- Z-A =:= Y-B,not(hayBloqueDiagonal([Z,Y],[A,B],LB)).
ataca([Z,Y],[[A,B]|R],LB,S):- Z-A =:= -(Y-B),not(hayBloqueDiagonal2([Z,Y],[A,B],LB)).
ataca(Q,[Car|Cdr],LB,P):-	ataca(Q,Cdr,LB,P).


hayBloqueDiagonal([Z,Y],[A,B],[[BX,BY]|R]):-Z-BX =:= Y-BY,
											menorque(Z,A,R1),
											mayorque(Z,A,R2),
											medio(BX,R1,R2).
hayBloqueDiagonal([Z,Y],[A,B],[[_,_]|R]):-hayBloqueDiagonal([Z,Y],[A,B],R).

hayBloqueDiagonal2([Z,Y],[A,B],[[BX,BY]|R]):-Z-BX =:= -(Y-BY),
											menorque(Z,A,R1),
											mayorque(Z,A,R2),
											medio(BX,R1,R2).
hayBloqueDiagonal2([Z,Y],[A,B],[[_,_]|R]):-hayBloqueDiagonal2([Z,Y],[A,B],R).


hayBloqueVertical(X,R1,R2,[[X,K]|_]):-menor(K,R2),
									  mayor(K,R1).
hayBloqueVertical(X,R1,R2,[[_,_]|R]):-hayBloqueVertical(X,R1,R2,R).

hayBloqueHorizontal(X,R1,R2,[[K,X]|_]):-menor(K,R2),
										mayor(K,R1).
hayBloqueHorizontal(X,R1,R2,[[_,_]|R]):-hayBloqueHorizontal(X,R1,R2,R).
								

medio(X,Y,Z):-X>Y,X<Z.								

menor(X,Y):-Y>X.
mayor(X,Y):-X>Y.

mayorque(X,Y,X):-X>Y.
mayorque(X,Y,Y):-Y>=X.

menorque(X,Y,X):-X<Y.
menorque(X,Y,Y):-Y=<X.