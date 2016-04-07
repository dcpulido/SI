// mars robot 1

/* Initial beliefs */
append([],L,L).
append([X|Xs],L,[X|Ys]):-
	append(Xs,L,Ys).

select (X, L, L1) :-
	.member(X, L) &
	append(Xfirst,[X|Xsecond],L) &
	append(Xfirst,Xsecond,L1).
	//.difference(L, [X], L1).

sol(L) :- sol(L,L).

sol([X|Xs],[X|Sols]):-
	//select (X, L, L1) &
	sol_aux(X, Xs, Sols).
sol([X|Xs],[Y|Sols]):-
	select (Y, Xs, LD) &
	sol_aux(Y, [X|LD], Sols).

sol_aux(X,[],[]).
sol_aux(X,[Y1],[Y1]):-
	.print(X,", ",Y1) &
	not (Y1 = X+1) &
	not (Y1 = X-1).	
sol_aux(X,[Y1,Y2|Ys],[Y1|SolP]):-
	.print(X,", ",Y1,", ",Y2,", ",Ys) &
	not (Y1 = X+1) &
	not (Y1 = X-1) &	
	sol_aux(Y1,[Y2|Ys],SolP).

/* Initial goal */

!start.

/* Plans */
+!start <-
	//!posiciones(L);
	!soluciones([1,3,5,7,2,0,6,4],Sols);
	!viewSols(Sols).
	
+!viewSols([Sol|Sols]) <-
	.print(Sol);
	!colocaQueen(Sol,0);
	.wait(200);
	!cleanBB;
	.wait(500);
	!viewSols(Sols).
	
-!viewSols([]). 
	
+!colocaQueen([Col|Cols],Fil) <-
	move_towards(Fil,Col);
	put(queen);
	!colocaQueen(Cols,Fil+1).
	
-!colocaQueen([],N).

+!cleanBB : queen(X,Y) <-
	clean(X,Y);
	.wait(100);
	!cleanBB.
	
-!cleanBB : true.

+!soluciones(L,ListaSol) //<- ?sol(L,Sol);.print("Solucion: ",Sol).
	: sol(L) <- 
	.print("Buscando soluciones.");
	.findall(Sol, sol(L,Sol), ListaSol);
	.print("Soluciones: ",ListaSol).
	
-!soluciones(Pos,ListaSol) <- 
	.print("============= no hay soluciones").

+!posiciones(L) 
	<- 	.findall(Num,.range(Num,0,7),L);
		.print(L).

