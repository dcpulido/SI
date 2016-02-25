// Agent peter in project HelloJASON.mas2j

/* Initial beliefs and rules */

/* Initial goals */

!start.

/* Plans */

+!start : true <- .send(jonas,tell,hello).

+hello[source(A)] 
  <- .print("I receive an hello from ",A);
     .send(A,tell,hello).
	 
+fire <-.print("im gonna stop the fire!!").
