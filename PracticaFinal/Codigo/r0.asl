/* Initial beliefs */
feach([],X,Y,LQ,LB,LL,LL).

feach([Car|Cdr],X,Y,LQ,LB,ListaInicial,R):-qfor(X,Y,LQ,[Car|LB],LR)&
														longitud(LR,K)&
														insertar(K,ListaInicial,LL)&
														feach(Cdr,X,Y,LQ,LB,LL,R).

mayorPosicionLista(Contador,[],_,R,R).														
mayorPosicionLista(Contador,[Car|Cdr],Referencia,PosicionMayor,R):-Car>Referencia&
														C=Contador+1&
														mayorPosicionLista(C,Cdr,Car,Contador,R).
mayorPosicionLista(Contador,[Car|Cdr],Referencia,PosicionMayor,R):-Car<=Referencia&
														C=Contador+1&
														mayorPosicionLista(C,Cdr,Referencia,PosicionMayor,R).

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

insertar(X,[],[X]).
insertar(X, Lista, [X|Lista]).


/* Initial goal */
+hole(Elx,Ely)[source(white)]<-
	-hole(Elx,Ely)[source(white)];
	.print("Petición de hole de white recibida, procesando");
	!tamTablero(Tam);
	.findall(q(C,D),queen(C,D),L);
	?monta(L,ListaQueens);
	!tablero(X,Y);
	.findall(q(C,D),block(C,D),LB);
	?monta(LB,ListaBlocks);
	.findall(q(C,D),hole(C,D),LH);
	?monta(LH,ListaHoles);
	?qfor(X,Y,ListaQueens,ListaBlocks,ListaLibresAntesHoles);
	?diferencia(ListaLibresAntesHoles,ListaHoles,ListaPosibles);
	?longitud(ListaPosibles,Longitud);
	if(Longitud<2){
		.send(white,tell,decline);
	}
	else{
		?diferencia(ListaPosibles,[[Elx,Ely]],ListaAux);
		?longitud(ListaAux,LongitudAux);
		if(Longitud >  LongitudAux){
			hole(Elx,Ely);
			.send(white,tell,accept);
		}else{
			.send(white,tell,decline);//Si al hacer la diferencia la longitud de la lista posibles es la misma, la posicion en la que quiere colocar no esta disponible. Colocar un hole ahi seria inutil.
		}
	}.

	
	
+block(Elx,Ely)[source(white)]<-
	-block(Elx,Ely)[source(white)];
	.print("Petición de block de white recibida, procesando");
	//Falta procesarla aquí
	!tamTablero(Tam);
	.findall(q(C,D),queen(C,D),L);
	?monta(L,ListaQueens);
	!tablero(X,Y);
	.findall(q(C,D),block(C,D),LB);
	?monta(LB,ListaBlocks);
	.findall(q(C,D),hole(C,D),LH);
	?monta(LH,ListaHoles);
	?qfor(X,Y,ListaQueens,ListaBlocks,ListaLibresAntesHoles);//Posibles sin bloque nuevo
	?diferencia(ListaLibresAntesHoles,ListaHoles,ListaPosibles);
	?longitud(ListaPosibles,LongitudAntes);
	?concat(ListaBlocks,[[Elx,Ely]],ListaNewBlocks);
	?qfor(X,Y,ListaQueens,ListaNewBlocks,ListaNewLibresAntesHoles);//Posibles con bloque nuevo
	?diferencia(ListaNewLibresAntesHoles,ListaHoles,ListaNewPosibles);
	?longitud(ListaNewPosibles,LongitudDespues);
	if(LongitudDespues<LongitudAntes){
		.send(white,tell,decline);
	}
	else{
		block(Elx,Ely);
		.send(white,tell,accept);
	}.
	
+hole(Elx,Ely)[source(black)]<-
	-hole(Elx,Ely)[source(black)];
	.print("Petición de hole de black recibida, procesando");
	!tamTablero(Tam);
	.findall(q(C,D),queen(C,D),L);
	?monta(L,ListaQueens);
	!tablero(X,Y);
	.findall(q(C,D),block(C,D),LB);
	?monta(LB,ListaBlocks);
	.findall(q(C,D),hole(C,D),LH);
	?monta(LH,ListaHoles);
	?qfor(X,Y,ListaQueens,ListaBlocks,ListaLibresAntesHoles);
	?diferencia(ListaLibresAntesHoles,ListaHoles,ListaPosibles);
	?longitud(ListaPosibles,Longitud);
	if(Longitud<2){
		.send(black,tell,decline);
	}
	else{
		?diferencia(ListaPosibles,[[Elx,Ely]],ListaAux);
		?longitud(ListaAux,LongitudAux);
		if(Longitud >  LongitudAux){
			hole(Elx,Ely);
			.send(black,tell,accept);
		}else{
			.send(black,tell,decline);//Si al hacer la diferencia la longitud de la lista posibles es la misma, la posicion en la que quiere colocar no esta disponible
		}
	}.
	
	
+block(Elx,Ely)[source(black)]<-
	-block(Elx,Ely)[source(black)];
	.print("Petición de block de black recibida, procesando");
	//Falta procesarla aquí
	!tamTablero(Tam);
	.findall(q(C,D),queen(C,D),L);
	?monta(L,ListaQueens);
	!tablero(X,Y);
	.findall(q(C,D),block(C,D),LB);
	?monta(LB,ListaBlocks);
	.findall(q(C,D),hole(C,D),LH);
	?monta(LH,ListaHoles);
	?qfor(X,Y,ListaQueens,ListaBlocks,ListaLibresAntesHoles);//Posibles sin bloque nuevo
	?diferencia(ListaLibresAntesHoles,ListaHoles,ListaPosibles);
	?longitud(ListaPosibles,LongitudAntes);
	?concat(ListaBlocks,[[Elx,Ely]],ListaNewBlocks);
	?qfor(X,Y,ListaQueens,ListaNewBlocks,ListaNewLibresAntesHoles);//Posibles con bloque nuevo
	?diferencia(ListaNewLibresAntesHoles,ListaHoles,ListaNewPosibles);
	?longitud(ListaNewPosibles,LongitudDespues);
	if(LongitudDespues<LongitudAntes){
		.send(black,tell,decline);
	}
	else{
		block(Elx,Ely);
		.send(black,tell,accept);
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


