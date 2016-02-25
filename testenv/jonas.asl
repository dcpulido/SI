// Agent jonas in project HelloJASON.mas2j

/* Initial beliefs and rules */

/* Initial goals */

/* Plans */
+hello[source(A)] 
  <- .print("I received a 'hello' from ",A);
     .send(A,tell,hello).
	 
+fire <-.print("run for ur lives!!!! ").
