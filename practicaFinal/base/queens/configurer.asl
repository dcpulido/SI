// mars robot 1
movs(0).
/* Initial beliefs */

/* Initial goal */

//!check(slots). 
!start.

/* Plans */
+!start : playAs(0) <- 
	.print("Aqui detallaremos la estrategia a emplear.");
	.wait(1000);
	?free(X,Y);
	queen(X,Y).

+!start <- 
	.wait(500);
	!start.

+queen(X,Y): size(N) &movs(Mov) <- 
	-free(X,Y);
	//-movs(Mov);
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
	.findall(pos(Col,Fil),(free(Col,Fil)[source(self)]),ListaLibres);
	.print("Lista de posiciones libres: ", ListaLibres);
	-+play(ListaLibres).
	
+play(ListaLibres): not playAs(0) & not playAs(1) <-
	//.print("Lista de posiciones libres: ", ListaLibres);
	.length(ListaLibres,Long);
	//.print("longitud de lista posiciones libres: ",Long);
	?maxBlocks(Max);
	//.print("numero de bloques que se pueden poner:", Max);
	if (Max=Long){
		for (.member(pos(I,J),ListaLibres)){
			block(I,J);
		}
	}.

+play([pos(X,Y)|Rest]): playAs(0) <-
	queen(X,Y).
	
+play(ListaLibres): playAs(1) <-
	.reverse(ListaLibres,[pos(X,Y)|Rest]);
	queen(X,Y).


+size(N) <- 
	+maxBlocks(N/4);
	+maxQueens(N/2);
	+maxHoles(N/4);
	for (.range(I,0,N-1)){
		for (.range(J,0,N-1)){
			+free(I,J);
			}
		};
	.print("Finalizada la inicialización").
			



