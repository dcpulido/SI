/* Initial beliefs */
qfor(Y,Y,LQ,LB,R):- mirafila(Y,Y,LQ,LB,R,Y).

qfor(X,Y,LQ,LB,K):-	X1=X+1 &
						concat(MF,R,K)&
						mirafila(X,Y,LQ,LB,MF,Y)&
						qfor(X1,Y,LQ,LB,R).
						
concat([], Cs, Cs).
concat([A|As],Bs,[A|Cs]):-
          concat(As, Bs, Cs).

mirafila(X,0,LQ,LB,[],S):-	ataca([X,0],LQ,LB,S).
mirafila(X,0,_,_,[[X,0]],_).
mirafila(X,Y,LQ,LB,MF,S):-	Y1=Y-1&
						ataca([X,Y],LQ,LB,S)&
						mirafila(X,Y1,LQ,LB,MF,S).
mirafila(X,Y,LQ,LB,[[X,Y]|MF],S):-	Y1=Y-1 &
								mirafila(X,Y1,LQ,LB,MF,S).
								
ataca([],[],_,_).
ataca([X,Z],[[X,Y]|R],LB,S):- mayorque(Z,Y,R1)&
							menorque(Z,Y,R2)&
							not(hayBloqueVertical(X,R2,R1,LB)).
ataca([Z,Y],[[X,Y]|R],LB,S):-mayorque(Z,X,R1)&
							menorque(Z,X,R2)&
							not(hayBloqueHorizontal(Y,R2,R1,LB)).
ataca([Z,Y],[[A,B]|R],LB,S):- Z-A == Y-B&not(hayBloqueDiagonal([Z,Y],[A,B],LB)).
ataca([Z,Y],[[A,B]|R],LB,S):- Z-A == -(Y-B)&not(hayBloqueDiagonal2([Z,Y],[A,B],LB)).
ataca(Q,[Car|Cdr],LB,P):-	ataca(Q,Cdr,LB,P).


hayBloqueDiagonal([Z,Y],[A,B],[[BX,BY]|R]):-Z-BX == Y-BY&
											menorque(Z,A,R1)&
											mayorque(Z,A,R2)&
											medio(BX,R1,R2).
hayBloqueDiagonal([Z,Y],[A,B],[[_,_]|R]):-hayBloqueDiagonal([Z,Y],[A,B],R).

hayBloqueDiagonal2([Z,Y],[A,B],[[BX,BY]|R]):-Z-BX == -(Y-BY)&
											menorque(Z,A,R1)&
											mayorque(Z,A,R2)&
											medio(BX,R1,R2).
hayBloqueDiagonal2([Z,Y],[A,B],[[_,_]|R]):-hayBloqueDiagonal2([Z,Y],[A,B],R).


hayBloqueVertical(X,R1,R2,[[X,K]|_]):-menor(K,R2)&
									  mayor(K,R1).
hayBloqueVertical(X,R1,R2,[[_,_]|R]):-hayBloqueVertical(X,R1,R2,R).

hayBloqueHorizontal(X,R1,R2,[[K,X]|_]):-menor(K,R2)&
										mayor(K,R1).
hayBloqueHorizontal(X,R1,R2,[[_,_]|R]):-hayBloqueHorizontal(X,R1,R2,R).
								

medio(X,Y,Z):-X>Y&X<Z.								

menor(X,Y):-Y>X.
mayor(X,Y):-X>Y.

mayorque(X,Y,X):-X>Y.
mayorque(X,Y,Y):-Y>=X.

menorque(X,Y,X):-X<Y.
menorque(X,Y,Y):-Y<=X.

monta([],[]).
monta([Car|Cdr],[[X,Y]|L]):- despieza(Car,X,Y) &
							 monta(Cdr,L).
						   
despieza([],[],[]).
despieza(q(X,Y),X,Y).

miembro(X,[X|_]).
miembro(X,[_|Y]):- miembro(X,Y).
		  
diferencia([],_,[]).
diferencia([A|B],K,M):- miembro(A,K)& diferencia(B,K,M).
diferencia([A|B],K,[A|M]):- not(miembro(A,K))& diferencia(B,K,M).

elemrandom(L,N,E):-
				get(L,N,E).
				
get([Car|Cdr],0,Car).
get([Car|Cdr],N,X):- N1=N-1 &
				get(Cdr,N1,X).
		  
longitud([],0).
longitud([_|T],N):-longitud(T,N0) & N=N0 + 1.

parset([X,Y],X,Y).

igual(X,X).

bloqueo([X,Y],[[X,Y]|_]).
bloqueo([X,Y],[_|Cdr]):-bloqueo([X,Y],Cdr).

playAs(0).

/* Initial goal */
!start.
+!start: true <- +player(0).
/* Plans */
+player(N):playAs(N)<-
			!play(N).
+player(N) : playAs(M) & not N==M <- .wait(300); .print("No es mi turno.").
+!play(P) <-
	//!jugadas(Njugadas);
	!tamTablero(Tam);
	.findall(q(C,D),queen(C,D),L);
	?monta(L,ListaQueens);
	!tablero(X,Y);
	.findall(q(C,D),block(C,D),LB);
	?monta(LB,ListaBlocks);
	.findall(q(C,D),hole(C,D),LH);
	?monta(LH,ListaHoles);
	?qfor(X,Y,ListaQueens,ListaBlocks,ListaLibresAntesHoles);
	
	if(.empty(ListaHoles)){?igual(ListaLibresAntesHoles,ListaPosibles);}
	else{?diferencia(ListaLibresAntesHoles,ListaHoles,ListaPosibles);}

	if(.empty(ListaPosibles)){
		//Montamos lista de posiciones amenazadas y no amenazadas sin piezas
		?qfor(X,Y,[],[],ListaTablero);
		?concat(ListaQueens,ListaBlocks,LInt);
		?concat(LInt,ListaHoles,ListaPiezas);
		?diferencia(ListaTablero,ListaPiezas,ListaDiferencia);
		//Si hay piezas en todas las posiciones, se acaba el juego
		if(.empty(ListaDiferencia)){.print("Fin");}
		else{
			.lenght(ListaPosibles,Referencia);
			Posicion=[-1,-1];
			ListaAux=[];
			//Recorremos las posiciones sin piezas comprobando que pasa poniendo un bloque en ellas
			for(.member(Elemento,ListaDiferencia)){
				qfor(X,Y,ListaQueens,[Elemento|ListaBlocks],ListaReferencia);
				if(.count(ListaReferencia)>Referencia){
					Posicion = Elemento;
					.lenght(ListaReferencia,Referencia);
				}
				//Montamos lista con las posiciones de bloques mas favorables
				if(.count(ListaReferencia)==Referencia){
					?concat(ListaAux,Elemento,L);
					ListaAux=L;
				}
			}
			//Comprueba si se encontraron posiciones favorables
			if(igual(Posicion,[-1,-1]) == true){
				.print("Fin");
			}else{
				//Selecciona el bloque a mandar
				?longitud(ListaPosibles,Long);
				!aleatorio(Long-1,Num);
				?elemrandom(ListaAux,Num,Ele);
				?qfor(X,Y,ListaQueens,[Ele|ListaBloques],ListaR);
				?diferencia(ListaR,ListaHoles,ListaNewPosibles);
				if(.empty(ListaNewPosibles)){
					.print("Fin");
				}
				else{
					//Envia el bloque
					?despieza(Ele,Ex,Ey);
					.send(r0,tell,block(Ex,Ey));
					.wait(+reply[source(r0)]);
					//Se espera por respuesta
					if(.count(accept,1) == true){
						.print("Percept aceptado");
							?longitud(ListaNewPosibles,Long);
							!aleatorio(Long-1,Num);
							?elemrandom(ListaNewPosibles,Num,Reina);
							?parset(Reina,Rx,Ry);
						//Se espera por bloque
						if(.count(block(Ex,Ey)) == 1){
							queen(Rx,Ry);
						}
						else{
							.wait(+bloque[source(QueensEnv)]);
							queen(Rx,Ry);
							-bloque[source(QueensEnv)];
						}
						-reply[source(r0)];
					}//Aqui iría el caso de que no acepte el percept el bloqueador
				}
			}
		}
	}else{
		.print("Sin Limpiar: ",ListaPosibles);
		?longitud(ListaPosibles,Long);
		!aleatorio(Long-1,Num);
		?elemrandom(ListaPosibles,Num,Ele);
		?parset(Ele,Elx,Ely);
		if(bloqueo([Elx,Ely],ListaB)){
			!play(P);
		}
		else{
			queen(Elx,Ely);
		}
	}.
	


+!jugadas(Njugadas):size(N)<-
Njugadas=N/2.
	
+!aleatorio(Long,Num)<-
.random(X);
Y = X*Long;
Num= math.round(Y).

	
+!tablero(X,Y):size(N)<-
	X=0;
	Y=N-1.
	
+!tamTablero(Tam):size(N)<-
	Tam=N.


