// mars robot 1

/* Initial beliefs */
perm([],[]).
perm([X|L],[X|L1]) :-
	perm(L,L1).
perm([X,Y|L],[Z|L2]) :-
	.member(Z,[Y|L]) &
	.difference([X,Y|L],[Z],L1) &
	perm(L1,L2).

sol(L):-
	checking(L,Check,0) &
	//.print("Lista de comprobaciones: ", Check) &
	sol_aux(L,Check,0).

checking([],[],N).
checking([X|Xs],[check(X,N)|Checks],N):-
	checking(Xs,Checks,N+1).
	
sol_aux([],L,N).//:- .print("LLegue al final de una lista con: ", L, " , ", N).
sol_aux([Col|Cols],Checks,N):- //el tercer argumento es la fila
	es_sol(Col, N, Checks) &
	//.print("La reina de la fila: ",N," puede ir en: ",Col) &
	sol_aux(Cols, Checks, N+1).

es_sol(Col,N,[]).//:- .print("Llegue al final.").
es_sol(Col, N, [check(Col,Y)|Checks]):-
	//.print("Estoy comprobando la reina en la posición que quiero: ",Col) &
	es_sol(Col,N,Checks).
es_sol(Col, N, [check(X,Y)|Checks]):-	
	//.print("pruebo: ",Col,",",N,",",X,",",Y) &
	not (Col = X - Y + N) &
	not (Col = X + Y - N) &
	es_sol(Col,N,Checks).

select (X, L, L1) :-
	.difference(L,[X],L1).

	
/* Initial goal */

//!check(slots). 
!start.

/* Plans */
+!start <- 
	!soluciones([1,3,5,7,2,0,6,4],Sol);
	Num = .length(Sol);
	.print("Hay: ", Num, " soluciones.");
	!view_sols(Sol).
	
+!colocaQueen(L,Fil) <-//: size(N)
	.member(Col,L);
	move_towards(Fil,Col);
	put(queen);
	.difference(L,[Col],L1);
	!colocaQueen(L1,Fil+1).
	
-!colocaQueen([],N).

+!cleanBB : queen(X,Y) <-
	clean(X,Y);
	.wait(200);
	!cleanBB.
	
-!cleanBB : true.

+!soluciones(Pos,ListaP) : perm(Pos,Sol) <- //sol([1,3,5,7,2,0,4,6]) <- //
	.print("Lista: ",Sol);
	.findall(L,perm(Pos,L)&sol(L),ListaP);
	.print("Soluciones: ",ListaP).
-!soluciones(Pos,Sol) <- .print("=============no es solucion").

+!posiciones(L) 
	<- 	.findall(Num,.range(Num,0,7),L);
		.print(L).

+!view_sols([Sol|Sols])
	<-	!viewSol(Sol,0);
		move_towards(0,7);
		.wait(7000);
		!cleanBB;
		!view_sols(Sols).
-!view_sols([])	<-
	.print("No hay más soluciones.").

+!viewSol([Col|Cols],N) <-
	move_towards(Col,N);
	put(queen);
	!viewSol(Cols,N+1).
	
-!viewSol([],N).
