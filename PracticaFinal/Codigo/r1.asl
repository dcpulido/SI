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
/* Initial goal */
!start.
+!start: true <- +player(0);
				!checkWhoAmI(K);
				.print("yo soy",K);			
				!play(P).


+!turno(2):not playAs(0) & not playAs(1) & not player(0) & not player(1).

+!turno(4):not playAs(0) & not playAs(1) & player(N).

+!turno(5):not playAs(N) & not player(M)<- .wait(200).

+!turno(6):playAs(1) & not player(N).
	
+!turno(7):playAs(0) & not player(N). 
		
+!turno(0):player(0) & playAs(0).

+!turno(1):player(1) & playAs(1).

+!turno(3):playAs(M) & player(N) & not N==M <- .wait(200).

+!checkWhoAmI(2):not playAs(0)& not playAs(1).
					
+!checkWhoAmI(M):playAs(M).
/* Plans */


+!play(P) <-
	!turno(N);
	
	
	if(N>=3){
		.count(queen(X,Y),Res);
		if(Res==1){
			-player(0)[source(self)];
		}
		!play(P);	
	}
	
	//!!CONFIGURADOOOOOOOOOR!!!
	else{
	if(N==2){
			.wait(1000);
			!turno(N2);
			if(N2==2){
				.print("soy un gran configurador");
				.send(black,tell,decline);
				.send(white,tell,decline);
				block(0,0);
				.wait(4000);
				.print("Termino turno configurador.");
			}
			!play(P);
			
	}else{
	
	//JUGADOOOOOOOOOOOOR!!!!!!!!!
	.print("Empiezo mi turno",N);
	.count(accept[source(configurer)],Naccept);
	.print("trace1");
	.count(decline[source(configurer)],Ndecline);
	if(Naccept==1){                   
		-accept[source(configurer)];
		.print("Peticion anterior aceptada.");
	}
	if(Ndecline==1){
		-decline[source(configurer)];
		.print("Peticion anterior denegada");
	}
	.print("trace2");
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

	//Montamos lista de posiciones amenazadas y no amenazadas sin piezas
	?qfor(X,Y,[],[],ListaTablero);
	?concat(ListaQueens,ListaBlocks,LInt);
	?concat(LInt,ListaHoles,ListaPiezas);
	?diferencia(ListaTablero,ListaPiezas,ListaDiferencia);
	
	.print("trace3");
	//ListaPosibles=Posiciones libre no amenazadas
	//ListaDiferencia=Posiciones amenazadas y no amenazadas libres
	
	//Si hay piezas en todas las posiciones, se acaba el juego
	if(.empty(ListaDiferencia)){.print("HE PERDIDO!!");}
	else{
	.print("trace4");
	if(.empty(ListaPosibles)){
		.print("HE PERDIDO!!");
		.suspend;
	}
	else{
	.print("trace5");
		?longitud(ListaPosibles,Long);
		!aleatorio(Long-1,XNum);
		?elemrandom(ListaPosibles,XNum,Reina);
		?parset(Reina,Rx,Ry);
		
		
		
		//Montamos la base para calcular la pos de bloque
		?concat(ListaQueens,Reina,ListaNewQueens);
		?qfor(X,Y,ListaNewQueens,ListaBlocks,ListaNewLibresAntesHoles);
		
		if(.empty(ListaHoles)){?igual(ListaLibresAntesHoles,ListaNewPosibles);}
		else{?diferencia(ListaNewLibresAntesHoles,ListaHoles,ListaNewPosibles);}
		.print("trace6");
		?concat(ListaNewQueens,ListaBlocks,LNewInt);
		?concat(LNewInt,ListaHoles,ListaNewPiezas);
		?diferencia(ListaTablero,ListaNewPiezas,ListaNewDiferencia);
		
		?longitud(ListaNewPosibles,Referencia);
		?feach(ListaNewDiferencia,X,Y,ListaNewQueens,ListaBlocks,[],ListaTam);
		?mayorPosicionLista(0,ListaTam,Referencia,-1,PosMayor);
		.print("trace9");
		if(PosMayor == -1){
		.print("trace7");
		-player(0)[source(self)];
		queen(Rx,Ry);
		!play(P);
		
			if(.empty(ListaNewDiferencia)){
				.print("No posicion optima bloque!!");
			}
		}
		else{
		.print("trace8");
				?elemrandom(ListaNewDiferencia,PosMayor,Bloque);
				?parset(Bloque,Bx,By);
				.print("Enviando solicitud de bloque en posicion:",Bx,By);
				.send(configurer,tell,block(Bx,By));
				//.wait(accept[source(configurer)] | decline[source(configurer)]);
				//Asegurando que no se hace trampa{
				-player(0)[source(self)];
				queen(Rx,Ry);
				!play(P);
			}
	}
	}
	}}.	
		
		
	
	
	
		


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


