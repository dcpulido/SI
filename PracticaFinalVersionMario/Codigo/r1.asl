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


+!turno(2):not playAs(0) & not playAs(1) & not player(0) & not player(1) & play[source(self)]<- -play[source(self)].

+!turno(8):not playAs(0) & not playAs(1) & not player(0) & not player(1) & not play[source(self)]<- .wait(1000);+play[source(self)].

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
			//.wait(2800);
			//!turno(N2);
			//if(N2==2){
			
				//Calculamos el tamano del tablero y comprobamos que nunca se pongan mas de N/4 bloques y holes
				!tamTablero(Tam);
				!tablero(C,D);
				.findall(q(X,Y),block(X,Y)[source(percept)],Bloques);
				.findall(q(X,Y),hole(X,Y)[source(percept)],Holes);
				.findall(q(X,Y),queen(X,Y)[source(percept)],Reinas);
				?concat(Bloques,Holes,Colocaciones);
				.print("Colocaciones",Colocaciones);
				?longitud(Colocaciones,LCol);
				
				if(LCol<Tam/4){
					.print("Aun puedo colocar piezas");
					//recuperar percepts
					.print("Recupero percepts");
					.findall(q(X,Y),block(X,Y)[source(white)],LBlockWhite);
					.findall(q(X,Y),block(X,Y)[source(black)],LBlockBlack);
					.findall(q(X,Y),hole(X,Y)[source(white)],LHoleWhite);
					.findall(q(X,Y),hole(X,Y)[source(black)],LHoleBlack);
					.print("Block white",LBlockWhite);
					.print("Block black",LBlockBlack);
					.print("Hole white",LHoleWhite);
					.print("Hole black",LHoleBlack);
					
					if(.empty(LBlockWhite) & .empty(LBlockBlack) & .empty(LHoleWhite) & .empty(LHoleBlack)){
						.print("No se recibieron peticiones de los jugadores en este turno.");
						.wait(player(1)[source(percept)]);
						.print("Fin del turno del configurador");
						!play(P);
					}else{
						if(.empty(LBlockWhite) & .empty(LHoleWhite)){
							.print("White no ha solicitado bloques ni holes este turno");
							//Procesar solo peticion de black
							if(.empty(LBlockBlack)){
								//Black ha solicitado un hole
								.print("Black ha solicitado hole en:",LHoleBlack);
								?monta(LHoleBlack,PHole);
								?elemrandom(PHole,0,Hole);
								?parset(Hole,Hx,Hy);
								-hole(Hx,Hy)[source(black)];
								//Montamos las listas
								?monta(Bloques,ListBloques);
								?monta(Reinas,ListReinas);
								?monta(Holes,ListHoles);
								?qfor(C,D,ListReinas,ListBloques,ListLibresSinHoles);
								?diferencia(ListLibresSinHoles,ListHoles,ListLibres);
								?longitud(ListLibres,Longitud);
								if(Longitud<2){
									.print("No quedan posiciones libres. Se declina la solicitud.");
									.send(black,tell,decline);
									.wait(player(1)[source(percept)]);
									.print("Termina el turno del configurador");
									!play(P);
								}else{
									?diferencia(ListLibres,[[Hx,Hy]],ListAux);
									?longitud(ListAux,LongitudAux);
									if(Longitud > LongitudAux){
										.print("Se acepta la peticion");
										.send(black,tell,accept);
										hole(Hx,Hy);
										.wait(player(1)[source(percept)]);
										.print("Termina el turno del configurador");
										!play(P);
									}else{
										.print("No se acepta la peticion. Escogiendo posicion disponible aleatoria");
										.send(black,tell,decline);
										?elemrandom(ListLibres,0,HoleRandom);
										?parset(HoleRandom,HRx,HRy);
										block(HRx,HRy);
										.wait(player(1)[source(percept)]);
										.print("Termina el turno del configurador");
										!play(P);
									}
								}
							}else{
								//Black ha solicitado un block
								.print("Black ha solicitado block en:",LBlockBlack);							
								?monta(LBlockBlack,PBlock);
								?elemrandom(PBlock,0,Block);
								?parset(Block,Bx,By);
								-block(Bx,By)[source(black)];
								//Montamos las listas
								?monta(Bloques,ListBloques);
								?monta(Reinas,ListReinas);
								?monta(Holes,ListHoles);
								?qfor(C,D,ListReinas,ListBloques,ListLibresSinHoles);
								?diferencia(ListLibresSinHoles,ListHoles,ListLibres);
								?longitud(ListLibres,LongitudAntes);//Longitud de la lista de posiciones disponibles
								?concat(ListBloques,[[Bx,By]],ListNewBloques);
								?qfor(C,D,ListReinas,ListNewBloques,ListNewLibresSinHoles);
								?diferencia(ListNewLibresSinHoles,ListHoles,ListNewLibres);
								?longitud(ListNewLibres,LongitudDespues);
								if(LongitudDespues<LongitudAntes){
									//Si la propuesta de bloque provoca que no se libren posiciones es una mala propuesta
									.print("Se rechaza la propuesta del jugador.Se busca una buena posicion para poner un bloque");
									.send(black,tell,decline);
									?qfor(C,D,[],[],CasillasTablero);
									?concat(ListReinas,ListBloques,ListMedia);
									?concat(ListMedia,ListHoles,PiezasTablero);
									?diferencia(CasillasTablero,PiezasTablero,CasillasSinPiezas);
									?feach(CasillasSinPiezas,C,D,ListReinas,ListBloques,[],ListaTamanos);
									?mayorPosicionLista(0,ListaTamanos,LongitudAntes,-1,Mayor);
									if(Mayor == -1){
										//Ninguna posicion buena para poner bloque
										.print("No hay ninguna posicion en la que poner un bloque libere posiciones del tablero");
										.print("Buscando entre las celdas no atacadas");
										if(LongitudAntes<2){
											.print("No quedan celdas no atacadas. No se colocara ningun bloque en este turno");
											.wait(player(1)[source(percept)]);
											.print("Termina el turno del configurador");
											!play(P);
										}else{
											.print("Se colocara un bloque en una celda no atacada aleatoria");
											?elemrandom(ListLibres,0,BloqueAPoner);
											?parset(BloqueAPoner,Bapx,Bapy);
											block(Bapx,Bapy);
											.wait(player(N)[source(percept)]);
											.print("Termina el turno del configurador");
											!play(P);
										}	
									}else{
										//Se ha encontrado la posicion buena
										?elemrandom(CasillasSinPiezas,Mayor,BloqueAPoner);
										?parset(BloqueAPoner,Bapx,Bapy);
										.print("Posicion optima encontrada. Se pone el bloque.");
										block(Bapx,Bapy);
										.wait(player(1)[source(percept)]);
										.print("Termina el turno del configurador");
										!play(P);
										
									}
									
								}else{
									//Si la propuesta de bloque genera mas posiciones libres es una buena propuesta
									.print("Se acepta la propuesta del jugador black");
									.send(black,tell,accept);
									block(Bx,By);
									.wait(player(1)[source(percept)]);
									.print("Termina el turno del configurador");
									!play(P);
								}
							}
							
						}else{
						
							if(.empty(LBlockBlack) & .empty(LHoleBlack)){
								.print("Black no ha solicitado bloques ni holes este turno");
								//Procesar solo peticion de white
								if(.empty(LBlockWhite)){
									//White ha solicitado un hole
									.print("White ha solicitado hole en:",LHoleWhite);
									?monta(LHoleWhite,PHole);
									?elemrandom(PHole,0,Hole);
									?parset(Hole,Hx,Hy);
									-hole(Hx,Hy)[source(white)];
									//Montamos las listas
									?monta(Bloques,ListBloques);
									?monta(Reinas,ListReinas);
									?monta(Holes,ListHoles);
									?qfor(C,D,ListReinas,ListBloques,ListLibresSinHoles);
									?diferencia(ListLibresSinHoles,ListHoles,ListLibres);
									?longitud(ListLibres,Longitud);
									if(Longitud<2){
										.print("No quedan posiciones libres. Se declina la solicitud.");
										.send(white,tell,decline);
										.wait(player(1)[source(percept)]);
										.print("Termina el turno del configurador");
										!play(P);
									}else{
										?diferencia(ListLibres,[[Hx,Hy]],ListAux);
										?longitud(ListAux,LongitudAux);
										if(Longitud > LongitudAux){
											.print("Se acepta la peticion");
											.send(white,tell,accept);
											hole(Hx,Hy);
											.wait(player(1)[source(percept)]);
											.print("Termina el turno del configurador");
											!play(P);
										}else{
											.print("No se acepta la peticion. Escogiendo posicion disponible aleatoria para poner un block.");
											.send(white,tell,decline);
											?elemrandom(ListLibres,0,HoleRandom);
											?parset(HoleRandom,HRx,HRy);
											block(HRx,HRy);
											.wait(player(1)[source(percept)]);
											.print("Termina el turno del configurador");
											!play(P);
										}
									}										
								}else{
									//White ha solicitado un block
									.print("White ha solicitado block en:",LBlockWhite);						
									?monta(LBlockWhite,PBlock);
									?elemrandom(PBlock,0,Block);
									?parset(Block,Bx,By);
									-block(Bx,By)[source(white)];
									//Montamos las listas
									?monta(Bloques,ListBloques);
									?monta(Reinas,ListReinas);
									?monta(Holes,ListHoles);
									?qfor(C,D,ListReinas,ListBloques,ListLibresSinHoles);
									?diferencia(ListLibresSinHoles,ListHoles,ListLibres);
									?longitud(ListLibres,LongitudAntes);//Longitud de la lista de posiciones disponibles
									?concat(ListBloques,[[Bx,By]],ListNewBloques);
									?qfor(C,D,ListReinas,ListNewBloques,ListNewLibresSinHoles);
									?diferencia(ListNewLibresSinHoles,ListHoles,ListNewLibres);
									?longitud(ListNewLibres,LongitudDespues);
									if(LongitudDespues<LongitudAntes){
										//Si la propuesta de bloque provoca que no se libren posiciones es una mala propuesta
										.print("Se rechaza la propuesta del jugador.Se busca una buena posicion para poner un bloque");
										.send(white,tell,decline);
										?qfor(C,D,[],[],CasillasTablero);
										?concat(ListReinas,ListBloques,ListMedia);
										?concat(ListMedia,ListHoles,PiezasTablero);
										?diferencia(CasillasTablero,PiezasTablero,CasillasSinPiezas);
										?feach(CasillasSinPiezas,C,D,ListReinas,ListBloques,[],ListaTamanos);
										?mayorPosicionLista(0,ListaTamanos,LongitudAntes,-1,Mayor);
										if(Mayor == -1){
											//Ninguna posicion buena para poner bloque
											.print("No hay ninguna posicion en la que poner un bloque libere posiciones del tablero");
											.print("Buscando entre las celdas no atacadas");
											if(LongitudAntes<2){
												.print("No quedan celdas no atacadas. No se colocara ningun bloque en este turno");
												.wait(player(1)[source(percept)]);
												.print("Termina el turno del configurador");
												!play(P);
											}else{
												.print("Se colocara un bloque en una celda no atacada aleatoria");
												?elemrandom(ListLibres,0,BloqueAPoner);
												?parset(BloqueAPoner,Bapx,Bapy);
												block(Bapx,Bapy);
												.wait(player(1)[source(percept)]);
												.print("Termina el turno del configurador");
												!play(P);
											}	
										}else{
											//Se ha encontrado la posicion buena
											?elemrandom(CasillasSinPiezas,Mayor,BloqueAPoner);
											?parset(BloqueAPoner,Bapx,Bapy);
											.print("Posicion optima encontrada. Se pone el bloque.");
											block(Bapx,Bapy);
											.wait(player(1)[source(percept)]);
											.print("Termina el turno del configurador");
											!play(P);
											
										}
										
									}else{
										//Si la propuesta de bloque genera mas posiciones libres es una buena propuesta
										.print("Se acepta la propuesta del jugador black");
										.send(white,tell,accept);
										block(Bx,By);
										.wait(player(1)[source(percept)]);
										.print("Termina el turno del configurador");
										!play(P);
									}								
								}
								
							}else{
								//Los dos envian peticiones
								//Procesar ambas
								.print("Se ha recibido solicitud de los dos jugadores.");
								if(.empty(LBlockBlack) & .empty(LBlockWhite)){
									//Los dos han solicitado hole
									.print("Black ha solicitado hole en:",LHoleBlack);
									.print("White ha solicitado hole en:",LHoleWhite);
									//Obtenemos la posicion en la que quieren colocar el hole y borramos el percept
									?monta(LHoleWhite,PBlockW);
									?elemrandom(PBlockW,0,BlockW);
									?parset(BlockW,BWx,BWy);
									-hole(BWx,BWy)[source(white)];
									?monta(LHoleBlack,PBlockB);
									?elemrandom(PBlockB,0,BlockB);
									?parset(BlockB,BBx,BBy);
									-hole(BBx,BBy)[source(black)];
									//Montamos las listas
									?monta(Bloques,ListBloques);
									?monta(Reinas,ListReinas);
									?monta(Holes,ListHoles);
									?qfor(C,D,ListReinas,ListBloques,ListLibresSinHoles);
									?diferencia(ListLibresSinHoles,ListHoles,ListLibres);
									?longitud(ListLibres,Longitud);
									if(Longitud < 2){
										.print("No quedan posiciones libres. Se declinan ambas solicitudes.");
										.send(black,tell,decline);
										.send(white,tell,decline);
										.wait(player(1)[source(percept)]);
										.print("Termina el turno del configurador");
										!play(P);	
									}else{
										?diferencia(ListLibres,[[BWx,BWy]],ListAuxW);
										?longitud(ListAuxW,LongitudAuxW);
										?diferencia(ListLibres,[[BBx,BBy]],ListAuxB);
										?longitud(ListAuxB,LongitudAuxB);
										if(LongitudAuxW == LongitudAuxB){
											//Si la jugada de ambos deja las mismas posiciones libres
											if(Longitud > LongitudAuxW){
												//Si dicha jugada es buena para ambos
												.print("Las propuestas de los dos jugadores son igual de buenas. No se prioriza ninguna de ellas");
												.send(black,tell,decline);
												.send(white,tell,decline);
												.print("Se procede a colocar block en posicion no atacada aleatoria");
												?elemrandom(ListLibres,0,HoleAPoner);
												?parset(HoleAPoner,HaPx,HaPy);
												block(HaPx,HaPy);
												.wait(player(1)[source(percept)]);
												.print("Termina el turno del configurador");
												!play(P);
											}else{
												//Si la jugada es igual de mala para ambos
												.print("Se declinan las propuestas de los dos jugadores porque no les ayudan");
												.send(black,tell,decline);
												.send(white,tell,decline);
												.print("Se procede a colocar block en posicion no atacada aleatoria");
												?elemrandom(ListLibres,0,HoleAPoner);
												?parset(HoleAPoner,HaPx,HaPy);
												block(HaPx,HaPy);
												.wait(player(1)[source(percept)]);
												.print("Termina el turno del configurador");
												!play(P);
											}
										}else{
											if(LongitudAuxW > LongitudAuxB){
												//Si es mejor la propuesta de Black
												.print("La propuesta de Black es mejor. Se deniega la propuesta de White");
												.send(black,tell,accept);
												.send(white,tell,decline);
												.print("Se procede a colocar el hole en la posicion solicitada por Black");
												hole(BBx,BBy);
												.wait(player(1)[source(percept)]);
												.print("Termina el turno del configurador");
												!play(P);
											}else{
												//Si es mejor la propuesta de White
												.print("La propuesta de White es mejor. Se deniega la propuesta de Black");
												.send(black,tell,decline);
												.send(white,tell,accept);
												.print("Se procede a colocar el hole en la posicion solicitada por White");
												hole(BWx,BWy);
												.wait(player(1)[source(percept)]);
												.print("Termina el turno del configurador");
												!play(P);
											}
										}
									}
								}else{
									if(.empty(LBlockBlack) & .empty(LHoleWhite)){
										//Black solicita Hole y white solicita block
										.print("Black ha solicitado hole en:",LHoleBlack);
										.print("White ha solicitado block en:",LBlockWhite);
										?monta(LBlockWhite,PBlock);
										?elemrandom(PBlock,0,Block);
										?parset(Block,Bx,By);
										-block(Bx,By)[source(white)];
										?monta(LHoleBlack,PHole);
										?elemrandom(PHole,0,Hole);
										?parset(Hole,Hx,Hy);
										-hole(Hx,Hy)[source(black)];
										?monta(Bloques,ListBloques);
										?monta(Reinas,ListReinas);
										?monta(Holes,ListHoles);
										?qfor(C,D,ListReinas,ListBloques,ListLibresSinHoles);
										?diferencia(ListLibresSinHoles,ListHoles,ListLibres);
										?longitud(ListLibres,Longitud);
										if(Longitud < 2){
											.print("No quedan posiciones libres. Se rechazan las solicitudes de ambos jugadores");
											.send(black,tell,decline);
											.send(white,tell,decline);
											.wait(player(1)[source(percept)]);
											.print("Termina el turno del configurador");
											!play(P);
										}else{
											//Si quedan posiciones libres
											?diferencia(ListLibres,[[Hx,Hy]],ListAux);
											?longitud(ListAux,LongitudHoles);
											if(Longitud > LongitudHoles){
												//La peticion de hole es buena, hay que comprobar la peticion de block
												?concat(ListBloques,[[Bx,By]],ListNewBloques);
												?qfor(C,D,ListReinas,ListNewBloques,ListNewLibresSinHoles);
												?diferencia(ListNewLibresSinHoles,ListHoles,ListNewLibres);
												?longitud(ListNewLibres,LongitudDespues);
												if(Longitud < LongitudDespues){
													//La peticion de block tambien es buena
													.print("Las dos peticiones son igualmente aceptables. Se declinan ambas para no favorecer a ningun jugador");
													.send(black,tell,decline);
													.send(white,tell,decline);
													.print("Se procede a colocar un block en una posicion no atacada aleatoria");
													?elemrandom(ListLibres,0,HoleAPoner);
													?parset(HoleAPoner,HaPx,HaPy);
													block(HaPx,HaPy);
													.wait(player(1)[source(percept)]);
													.print("Termina el turno del configurador");
													!play(P);
												}else{
													//La peticion de block es mala
													.print("Se acepta la peticion de hole de Black y se rechaza la peticion de block de White");
													.send(black,tell,accept);
													.send(white,tell,decline);
													hole(Hx,Hy);
													.wait(player(1)[source(percept)]);
													.print("Termina el turno del configurador");
													!play(P);
												}
											}else{
												//La peticion de hole es mala, hay que comprobar la peticion de block
												?concat(ListBloques,[[Bx,By]],ListNewBloques);
												?qfor(C,D,ListReinas,ListNewBloques,ListNewLibresSinHoles);
												?diferencia(ListNewLibresSinHoles,ListHoles,ListNewLibres);
												?longitud(ListNewLibres,LongitudDespues);
												if(Longitud < LongitudDespues){
													//La peticion de block es buena
													.print("Se acepta la peticion de bloque de White y se rechaza la peticion de hole de Black");
													.send(black,tell,decline);
													.send(white,tell,accept);
													block(Bx,By);
													.wait(player(1)[source(percept)]);
													.print("Termina el turno del configurador");
													!play(P);
												}else{
													//La peticion de block tambien es mala
													.print("Ninguna de las dos solicitudes es favorable. Se deniegan");
													.send(black,tell,decline);
													.send(white,tell,decline);
													.print("Colocando block en una celda no atacada del tablero aleatoria");
													?elemrandom(ListLibres,0,HoleAPoner);
													?parset(HoleAPoner,HaPx,HaPy);
													block(HaPx,HaPy);
													.wait(player(1)[source(percept)]);
													.print("Termina el turno del configurador");
													!play(P);	
												}
											}
										}	
									}else{
										if(.empty(LHoleBlack) & .empty(LBlockWhite)){
											//Black solicita Block y white solicita hole
											.print("Black ha solicitado block en:",LBlockBlack);
											.print("White ha solicitado hole en:",LHoleWhite);
											?monta(LBlockBlack,PBlock);
											?elemrandom(PBlock,0,Block);
											?parset(Block,Bx,By);
											-block(Bx,By)[source(black)];
											?monta(LHoleWhite,PHole);
											?elemrandom(PHole,0,Hole);
											?parset(Hole,Hx,Hy);
											-hole(Hx,Hy)[source(white)];
											?monta(Bloques,ListBloques);
											?monta(Reinas,ListReinas);
											?monta(Holes,ListHoles);
											?qfor(C,D,ListReinas,ListBloques,ListLibresSinHoles);
											?diferencia(ListLibresSinHoles,ListHoles,ListLibres);
											?longitud(ListLibres,Longitud);
											if(Longitud < 2){
												.print("No quedan posiciones libres. Se rechazan las solicitudes de ambos jugadores");
												.send(black,tell,decline);
												.send(white,tell,decline);
												.wait(player(1)[source(percept)]);
												.print("Termina el turno del configurador");
												!play(P);
											}else{
												//Si quedan posiciones libres
												?diferencia(ListLibres,[[Hx,Hy]],ListAux);
												?longitud(ListAux,LongitudHoles);
												if(Longitud > LongitudHoles){
													//La peticion de hole es buena, hay que comprobar la peticion de block
													?concat(ListBloques,[[Bx,By]],ListNewBloques);
													?qfor(C,D,ListReinas,ListNewBloques,ListNewLibresSinHoles);
													?diferencia(ListNewLibresSinHoles,ListHoles,ListNewLibres);
													?longitud(ListNewLibres,LongitudDespues);
													if(Longitud < LongitudDespues){
														//La peticion de block tambien es buena
														.print("Las dos peticiones son igualmente aceptables. Se declinan ambas para no favorecer a ningun jugador");
														.send(black,tell,decline);
														.send(white,tell,decline);
														.print("Se procede a colocar un block en una posicion no atacada aleatoria");
														?elemrandom(ListLibres,0,HoleAPoner);
														?parset(HoleAPoner,HaPx,HaPy);
														block(HaPx,HaPy);
														.wait(player(1)[source(percept)]);
														.print("Termina el turno del configurador");
														!play(P);
													}else{
														//La peticion de block es mala
														.print("Se acepta la peticion de hole de White y se rechaza la peticion de block de Black");
														.send(black,tell,decline);
														.send(white,tell,accept);
														hole(Hx,Hy);
														.wait(player(1)[source(percept)]);
														.print("Termina el turno del configurador");
														!play(P);
													}
												}else{
													//La peticion de hole es mala, hay que comprobar la peticion de block
													?concat(ListBloques,[[Bx,By]],ListNewBloques);
													?qfor(C,D,ListReinas,ListNewBloques,ListNewLibresSinHoles);
													?diferencia(ListNewLibresSinHoles,ListHoles,ListNewLibres);
													?longitud(ListNewLibres,LongitudDespues);
													if(Longitud < LongitudDespues){
														//La peticion de block es buena
														.print("Se acepta la peticion de bloque de Black y se rechaza la peticion de hole de White");
														.send(black,tell,accept);
														.send(white,tell,decline);
														block(Bx,By);
														.wait(player(1)[source(percept)]);
														.print("Termina el turno del configurador");
														!play(P);
													}else{
														//La peticion de block tambien es mala
														.print("Ninguna de las dos solicitudes es favorable. Se deniegan");
														.send(black,tell,decline);
														.send(white,tell,decline);
														.print("Colocando block en una celda no atacada del tablero aleatoria");
														?elemrandom(ListLibres,0,HoleAPoner);
														?parset(HoleAPoner,HaPx,HaPy);
														block(HaPx,HaPy);
														.wait(player(1)[source(percept)]);
														.print("Termina el turno del configurador");
														!play(P);	
													}
												}
											}
										}else{
											//Los dos han solicitado block
											.print("Black ha solicitado block en:",LBlockBlack);
											.print("White ha solicitado block en:",LBlockWhite);
											?monta(LBlockBlack,PBlock);
											?elemrandom(PBlock,0,Block);
											?parset(Block,BBx,BBy);
											-block(BBx,BBy)[source(black)];
											?monta(LBlockWhite,PHole);
											?elemrandom(PHole,0,Hole);
											?parset(Hole,BWx,BWy);
											-block(BWx,BWy)[source(white)];
											?monta(Bloques,ListBloques);
											?monta(Reinas,ListReinas);
											?monta(Holes,ListHoles);
											?qfor(C,D,ListReinas,ListBloques,ListLibresSinHoles);
											?diferencia(ListLibresSinHoles,ListHoles,ListLibres);
											?longitud(ListLibres,Longitud);
											if(Longitud < 2){
												.print("No quedan posiciones libres. Se rechazan las solicitudes de ambos jugadores");
												.send(black,tell,decline);
												.send(white,tell,decline);
												.wait(player(1)[source(percept)]);
												.print("Termina el turno del configurador");
												!play(P);
											}else{
												.print("Buscando posicion optima para poner un bloque");
												?concat(ListReinas,ListBloques,ListMedia);
												?concat(ListMedia,ListHoles,CasillasOcupadas);
												?qfor(C,D,[],[],CasillasTablero);
												?diferencia(CasillasTablero,CasillasOcupadas,CasillasLibres);
												?feach(CasillasLibres,C,D,ListReinas,ListBloques,[],ListaTamanos);
												?mayorPosicionLista(0,ListaTamanos,Longitud,-1,Mayor);
												if(Mayor == -1){
													.print("Ninguna posicion del tablero es optima para poner un bloque");
													.print("Se deniegan las peticiones de los jugadores");
													.send(black,tell,decline);
													.send(white,tell,decline);
													.print("Procediendo a colocar bloque en posicion no atacada aleatoria");
													?elemrandom(ListLibres,0,APoner);
													?parset(APoner,APx,APy);
													block(APx,APy);
													.wait(player(1)[source(percept)]);
													.print("Termina el turno del configurador");
													!play(P);
												}else{
													?elemrandom(CasillasLibres,Mayor,APoner);
													?parset(APoner,APx,APy);
													.print("Encontrada posicion optima en:",APoner);
													if(BBx == APx & BBy == APy){
														if(BBx == BWx & BBy == BWy){
															.print("Ambas peticiones coinciden con la optima. Se aceptan");
															.send(black,tell,accept);
															.send(white,tell,accept);
														}else{
															.print("Se acepta la peticion de black");
															.send(black,tell,accept);
															.send(white,tell,decline);
														}
													}else{
														if(BWx == APx & BWy == APy){
															.print("Se acepta la peticion de white");
															.send(black,tell,decline);
															.send(white,tell,accept);
														}else{
															.print("Ninguna peticion es optima. Se deniegan las dos");
															.send(black,tell,decline);
															.send(white,tell,decline);
														}
													}
													block(APx,APy);
													.wait(player(1)[source(percept)]);
													.print("Termina el turno del configurador");
													!play(P);
												}
											}
										}
									}
								}
								
							}
						}
					}
	
				}else{
					//Si ya se han puesto N/4 piezas
					.print("Ya no se me permite colocar mas piezas");
					.wait(player(1)[source(percept)]);
					.print("Termina el turno del configurador");
					!play(P);
				}				
			//}//if N2
			
			
			
			
			//Termina configurador
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
	if(.empty(ListaDiferencia)){.print("HE PERDIDO!!"); .suspend;}
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
		?concat(ListaQueens,[Reina],ListaNewQueens);
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
		.print("PosMayor",PosMayor);
		if(PosMayor == -1){
			.print("trace7");
			-player(0)[source(self)];
			if(.empty(ListaNewDiferencia)){
				.print("trace10");
				
					.findall(q(C,D),queen(C,D),L00);
					?monta(L00,ListaQueens00);
					.findall(q(C,D),block(C,D),LB00);
					?monta(LB00,ListaBlocks00);
					.findall(q(C,D),hole(C,D),LH00);
					?monta(LH00,ListaHoles00);
					?concat(ListaQueens00,ListaBlocks00,LInt00);
					?concat(LInt00,ListaHoles00,ListaPiezas00);
					if(bloqueo([Rx,Ry],ListaPiezas00)){
						.count(reintenta[source(self)],Control);
						if(Control == 0){
							+reintenta[source(self)];
							.print("Iba a colocar la pieza en la ultima posicion del configurador. Reintentando en otra posicion");
							!play(P);
						}else{
							-reintenta[source(self)];
							.print("No he conseguido calcular una mejor posicion. Yo pierdo");
							.suspend;
						}
					}else{
						queen(Rx,Ry);
						!play(P);					
					}
				

			}else{
				.print("trace11");
				?elemrandom(ListaNewDiferencia,0,Hole);
				?parset(Hole,Hx,Hy);
				.print("Solicitando Hole en",Hx,Hy);
				.send(configurer,tell,hole(Hx,Hy));
				
				
				.findall(q(C,D),queen(C,D),L01);
				?monta(L01,ListaQueens01);
				.findall(q(C,D),block(C,D),LB01);
				?monta(LB01,ListaBlocks01);
				.findall(q(C,D),hole(C,D),LH01);
				?monta(LH01,ListaHoles01);
				?concat(ListaQueens01,ListaBlocks01,LInt01);
				?concat(LInt01,ListaHoles01,ListaPiezas01);
				if(bloqueo([Rx,Ry],ListaPiezas01)){
					.count(reintenta[source(self)],Control);
					if(Control == 0){
						+reintenta[source(self)];
						.print("Iba a colocar la pieza en la ultima posicion del configurador. Reintentando en otra posicion");
						!play(P);
					}else{
						-reintenta[source(self)];
						.print("No he conseguido calcular una mejor posicion. Yo pierdo");
						.suspend;
					}
				}else{
					queen(Rx,Ry);
					!play(P);					
				}
				
				
			}

		}
		else{
			.print("trace8");

			//.wait(accept[source(configurer)] | decline[source(configurer)]);
			//Asegurando que no se hace trampa{
			-player(0)[source(self)];
			
				.findall(q(C,D),queen(C,D),L02);
				?monta(L02,ListaQueens02);
				.findall(q(C,D),block(C,D),LB02);
				?monta(LB02,ListaBlocks02);
				.findall(q(C,D),hole(C,D),LH02);
				?monta(LH02,ListaHoles02);
				?concat(ListaQueens02,ListaBlocks02,LInt02);
				?concat(LInt02,ListaHoles02,ListaPiezas02);
				if(bloqueo([Rx,Ry],ListaPiezas02)){
					.count(reintenta[source(self)],Control);
					if(Control == 0){
						+reintenta[source(self)];
						.print("Iba a colocar la pieza en la ultima posicion del configurador. Reintentando en otra posicion");
						!play(P);
					}else{
						-reintenta[source(self)];
						.print("No he conseguido calcular una mejor posicion. Yo pierdo");
						.suspend;
					}

				}else{
					?elemrandom(ListaNewDiferencia,PosMayor,Bloque);
					?parset(Bloque,Bx,By);
					.print("Enviando solicitud de bloque en posicion:",Bx,By);
					.send(configurer,tell,block(Bx,By));
					queen(Rx,Ry);
					!play(P);					
				}
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


