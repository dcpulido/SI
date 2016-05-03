ataca([],[],_,_).
ataca([X,Z],[[X,Y]|R],LB,S):- mayorque(Z,Y,R1),
							menorque(Z,Y,R2),
							not(hayBloqueVertical(X,R2,R1,LB)).
ataca([Z,Y],[[X,Y]|R],LB,S):-mayorque(Z,X,R1),
							menorque(Z,X,R2),
							not(hayBloqueHorizontal(Y,R2,R1,LB)).
ataca(Q,[Car|Cdr],LB,P):-	ataca(Q,Cdr,LB,P).





hayBloqueVertical(X,R1,R2,[[X,K]|_]):-menor(K,R2),
									  mayor(K,R1).
hayBloqueVertical(X,R1,R2,[[_,_]|R]):-hayBloqueVertical(X,R1,R2,R).

hayBloqueHorizontal(X,R1,R2,[[K,X]|_]):-menor(K,R2),
										mayor(K,R1).
hayBloqueHorizontal(X,R1,R2,[[_,_]|R]):-hayBloqueHorizontal(X,R1,R2,R).
										


menor(X,Y):-Y>X.
mayor(X,Y):-X>Y.

mayorque(X,Y,X):-X>Y.
mayorque(X,Y,Y):-Y>=X.

menorque(X,Y,X):-X<Y.
menorque(X,Y,Y):-Y=<X.