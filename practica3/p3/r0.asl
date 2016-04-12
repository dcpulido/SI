// mars robot 1

/* Initial beliefs */

/* Initial goal */

//!check(slots). 
!start.

/* Plans */
+!start : playAs(0) <-
	queen(1,0);
	.wait(100);
	.print("Espero mi turno de blancas.");
	block(2,2);
	.wait(play(0));
	queen(5,2);
	-play(0);
	.wait(100);
	.print("Espero mi turno de blancas.");
	.wait(play(0));
	queen(4,4);
	-play(0);
	.wait(100);
	.print("Espero mi turno de blancas.");
	.wait(play(0));
	queen(0,6);
	-play(0);
	.wait(500);
	move_towards(7,7).

+!start : playAs(1) <-
	wait(player(1)); 
	.print("Espero mi turno de negras.");
	.wait(play(1));
	queen(3,1);
	-play(1);
	.wait(100);
	.print("Espero mi turno de negras.");
	.wait(play(1));
	queen(7,3);
	-play(1);
	.wait(100);
	block(3,3);
	.print("Espero mi turno de negras.");
	.wait(play(1));
	queen(6,5);
	-play(1);
	.wait(100);
	.print("Espero mi turno de negras.");
	.wait(play(1));
	queen(2,7);
	move_towards(0,0).

+player(N) : playAs(N) <- .wait(300); +play(N).

+player(N) : playAs(M) & not N==M <- .wait(300); .print("No es mi turno.").


