%algoritmo prolog para comprobar si existe jaque en Nreinas

ataca([],[]).
ataca([X,_],[[X,_]|_]).
ataca([_,Y],[[_,Y]|_]).
%orden de los parametros para horizontalidad o verticalidad
ataca(Q,[Car|Cdr]):-ataca(Q,Cdr);
					ataca(Q,1,[Car|Cdr]).

ataca([X1,X2],P,[[C1,C2]|_]):-comprueba1(X1,X2,P,C1,C2);
							  comprueba2(X1,X2,P,C1,C2);
							  comprueba3(X1,X2,P,C1,C2);							  
							  comprueba4(X1,X2,P,C1,C2);							  
							  comprueba5(X1,X2,P,C1,C2).
				 
ataca(X,P,[_|R]):- P1 is P + 1,
				   ataca(X,P1,R).

comprueba1(X1,X2,P,C1,C2):-X1 is C1+P,
						   X2 is C2+P.
comprueba2(X1,X2,P,C1,C2):-X1 is C1-P,
						   X2 is C2+P.
comprueba3(X1,X2,P,C1,C2):-X1 is C1-P,
						   X2 is C2+P.
comprueba4(X1,X2,P,C1,C2):-X1 is C1-P,
						   X2 is C2+P.
comprueba5(X1,X2,_,C1,C2):-X1 = C1,
						   X2 = C2.					   