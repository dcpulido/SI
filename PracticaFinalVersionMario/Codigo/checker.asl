// mars robot 1
movs(0).
/* Initial beliefs */

/* Initial goal */

//!check(slots). 
!start.
/* Plans */

+!start : size(N) <-
	.print("La partida se realizará en un tablero de: ", N," x ",N);
	!initiateBB(N); // Iniciamos el modelo interno del tablero
	.wait(5000); // Damos un poco de emoción al juego
	.print("Iniciamos la partida.");
	!nextPlay. //Comenzamos a jugar segun el rol asignado
	
+!start : not size(N) <- 
	!start. // Impedimos que el agente inicie el juego antes de tiempo.

+!initiateBB(N) <- //: true <- 
	.print("Inicializando el modelo interno del tablero.");
	+maxBlocks(N/4); // Limite de bloques que se pueden colocar
	+maxHoles(N/4);  // Limite de agujeros que se pueden colocar
	+maxQueens(N/2); // Limite de reinas que puede colocar cada juagador
	for (.range(I,0,N-1)){
		for (.range(J,0,N-1)){
			+free(I,J);
			}
		};
	+update(done);
	+play(0);
	.print("Finalizada la creacion del modelo del tablero.").
	

+!nextPlay : not free(_,_) <-
	.print("No hay movimientos posibles.").
	
+!nextPlay : playAs(0) & play(0) <- 
	?size(N);
	-play(0);
	.print("Blancas comienzan moviendo siempre en pos(", N/2, ",", N/2, " )");
	queen(N/2,N/2);
	.wait(2000);
	!nextPlay.
	
+!nextPlay : playAs(1) & play(0) <- 
	?size(N);
	-play(0);
	.print("Negras pasa turno.");
	.wait(2000);
	!nextPlay.

+!nextPlay : not playAs(_) & play(0) <- 
	?size(N);
	-play(0);
	.print("El configurador pasa turno.");
	.wait(2000);
	!nextPlay.

+!nextPlay : playAs(_) & not player(_) <- 
	.wait(2000);
	.print("Los jugadores esperan su turno.");
	.wait(4000);
	if (play(0)) {
		.print("Algo huele a podrido.");
	} else {
		.print("NO HAY play(0)");
	};
	!nextPlay.

+!nextPlay : playAs(Player) & player(Player) <- 
	//.findall(pos(X,Y), free(X,Y), ListaLibres);
	//.length(ListaLibres, N);
	//.wait(500);
	.print("Coloco como: ", Player);
	.wait(1000);
	if (playAs(0)) {
		.print("Mueven blancas.");
		!selectWhiteMov; 
	} else {
		.print("Mueven negras.");
		!selectBlackMov;
	};
	.wait(1500);
	!nextPlay.


+!nextPlay : not playAs(_) & not player(_) & update(done) & free(_,_) <- 
	.print("Coloco como bloqueador donde me peta .....");
	!selectBlockMov;
	.wait(3500);
	!nextPlay. 
	
+!nextPlay : not playAs(_) & not player(_) & maxBlocks(NB) & maxHoles(NH) & maxQueens(NQ) & NB+NH<=NQ/2 <- 
	.print("El configurador no puede mover más."). 
		
+!nextPlay : free(_,_) <-
	.print("Aun hay movimientos posibles.");
	.wait(1000);
	!nextPlay.

+!accept(Player) : accepted(block(X,Y)) <-
	.send(Player,tell,accept).

+!accept(Player) <-
	.print("Acepto en cualquier caso.").

+!selectBlockMov : free(_,_) & movs(NM) & maxQueens(NQ) & NM < NQ/2 <- 
	.print("El configurador pasa turno.").
	
+!selectBlockMov : free(_,_) & movs(NM) & maxQueens(NQ) & NM >= NQ/2 <- 
	.findall(pos(X,Y), free(X,Y), Lista);
	.reverse(Lista,ListaLibres);
	.length(ListaLibres, Num);
	.print("Posiciones libres segun el configurador: ",ListaLibres);
	//.wait(500);
	?maxHoles(NH);
	?maxBlocks(NB);
	if (NB = NH) {
		.nth(Num-1,ListaLibres,pos(X,Y));
		.print("Quedan tantos bloques como agujeros.");
	} else {
		.nth(0,ListaLibres,pos(X,Y));
		.print("No hay el mismo numero de bloques que de agujeros.");
	}; 
	.wait(accept(Player), 4900);
	if (accepted(block(I,J))) {
		-accepted(block(I,J));
		block(I,J); 
		};
	if (accepted(hole(I,J))) {
		-accepted(hole(I,J));
		hole(I,J); 
		};
	if (not accepted(_)) {
		if (not NB = NH) {
			block(X,Y);
		} else {
			hole(X,Y);
		}; 	
	};
	.wait(500);
	.print("Bloqueador ha movido a pos(",X,", ",Y,")").
	

+!selectBlockMov : maxBlocks(NB) & maxHoles(NH) & maxQueens(NQ) & NB+NH<=NQ/2 <- 
	.print("No tengo más movimientos permitidos.").

+!selectBlockMov : not free(X,Y) <- 
	.print("No hay movimientos elegibles.").

+!selectWhiteMov : not free(X,Y) <- 
	.print("No hay movimientos elegibles.").

+!selectWhiteMov : maxQueens(Medio) & free(_,_)<- 
	.findall(pos(X,Y), free(X,Y), Lista);
	.reverse(Lista,ListaLibres);
	.length(ListaLibres, Num);
	if (Num>0 & .member(pos(Medio/2,Y),ListaLibres)) {
		queen(Medio/2,Y);
		.print("Blancas con conciencia mueve a pos(",Medio/2,", ",Y,")");
	} else {
		if (Num>0 & .member(pos(X,Medio/2),ListaLibres)) {
			queen(X,Medio/2);
			.print("Blancas con conciencia mueve a pos(",X,", ",Medio/2,")");
		} else {
			if (Num>0) {
				.nth(Num-1,ListaLibres,pos(I,J));
				queen(I,J);
				.print("Blancas mueve porque quiere a pos(",I,", ",J,")");
			} else {
				.print("La lista esta vacia.");
			}
		}
	};	
	.wait(500).

+!selectBlackMov : not free(X,Y) <- 
	.print("No hay posiciones libres para negras.").

+!selectBlackMov : free(X,Y) <- 
	queen(X,Y);
	.print("Negras mueve con conciencia a la primera posicion libre encontrada que es: pos(",X,", ",Y,")").


+block(X,Y) [source(percept)] : maxBlocks(NB) <- 
	-update(done);
	-free(X,Y);
	//.wait(300);
	-+maxBlocks(NB-1);
	+update(done).

+block(X,Y) [source(Ag)] : not Ag == percept & accepted(_) <- 
	.print("Lo siento ya acepte una petición anterior.");
	.send(Ag,tell,decline).

	
+hole(X,Y) [source(percept)] : maxHoles(NH) <- 
	-update(done);
	-free(X,Y);
	//.wait(200);
	-+maxHoles(NH-1);
	+update(done).

+hole(X,Y) [source(Ag)] : not Ag == percept & accepted(_) <- 
	.print("Lo siento ya acepte una petición anterior.");
	.send(Ag,tell,decline).

+block(X,Y) [source(Ag)] : not Ag == percept & not accepted(_) <- 
	.findall(pos(I,J), free(I,J), ListaLibres);
	.length(ListaLibres, Num);
	if (Num > 1 & .member(pos(X,Y), ListaLibres)) {
		if (not accepted(_)){
			+accepted(block(X,Y));
			!accept(Ag);
		} else {
			.send(Ag,tell,decline)
		}
	} else {
			.send(Ag,tell,decline)
	}.

+hole(X,Y) [source(Ag)] : not Ag == percept & not accepted(_) <- 
	.findall(pos(I,J), free(I,J), ListaLibres);
	.length(ListaLibres, Num);
	if (Num > 1 & .member(pos(X,Y), ListaLibres)) {
		if (not accepted(_)){
			+accepted(hole(X,Y));
			!accept(Ag);
		} else {
			.send(Ag,tell,decline)
		}
	} else {
			.send(Ag,tell,decline)
	}.



+queen(X,Y): size(N) & movs(Mov) <- 
	-update(done);
	-free(X,Y);
	-+movs(Mov+1);
	for (.range(I,0,N-1)){
		if (not I=X){
			-free(I,Y);
			if (Mov mod 2==1) {
				+queenAttack(black,I,Y);
			} else {
				+queenAttack(white,I,Y);
			}
		};
		if (not I=Y){
			-free(X,I);
			if (Mov mod 2==1) {
				+queenAttack(black,X,I);
			} else {
				+queenAttack(white,X,I);
			}
		};
		if ((not I=0) & (Y+I<N) & (X+I<N)){
			-free(X+I,Y+I);
			if (Mov mod 2==1) {
				+queenAttack(black,X+I,Y+I);
			} else {
				+queenAttack(white,X+I,Y+I);
			}
		};
		if ((not I=0) & (Y-I>=0) & (X-I>=0)){
			-free(X-I,Y-I);
			if (Mov mod 2==1) {
				+queenAttack(black,X-I,Y-I);
			} else {
				+queenAttack(white,X-I,Y-I);
			}
		};
		if ((not I=0) & (Y-I>=0) & (X+I<N)){
			-free(X+I,Y-I);
			if (Mov mod 2==1) {
				+queenAttack(black,X+I,Y-I);
			} else {
				+queenAttack(white,X+I,Y-I);
			}
		};
		if ((not I=0) & (Y+I<N) & (X-I>=0)){
			-free(X-I,Y+I);
			if (Mov mod 2==1) {
				+queenAttack(black,X-I,Y+I);
			} else {
				+queenAttack(white,X-I,Y+I);
			}
		};			
	};
	+update(done).

	



