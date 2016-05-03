
// Implementation of the example described in chapter 2
// of the Jason's manual

MAS mars {

    infrastructure: Centralised

    environment: QueensEnv
    
    agents:  //r1;r2;//r0; 
        blk1  C:\Users\kurdakri\Desktop\Practica4\r0.asl [beliefs="playAs(0)"];

        blk2  C:\Users\kurdakri\Desktop\Practica4\r0.asl [beliefs="playAs(1)"];

        white  C:\Users\kurdakri\Desktop\Practica4\r1.asl [beliefs="playAs(0)"];

        black  C:\Users\kurdakri\Desktop\Practica4\r1.asl [beliefs="playAs(1)"];

}




TAREAS A SEGUIR

A)MODIFICAR BLOQUEADOR PARA CONVERTIRLO EN CONFIGURADORs
	muros(crean refugios cortando la linea de amenaza)
	agujeros(lo mismo q los bloiques hasta ahora)
	1:implementar colocacion de bloques y aguijeros
	2:implementar metodop de escucha y de respuyesta para comunicacion
			comunicacion con los agentes 
				.send(configurer, tell , block(X,Y)/hole(X,Y))
				.send(AG,tell,accept/decline)	
	3:estrategia coplocacion block(colocacion en celda no atacada)
	4:estrategia colocacion hole(colocacion en celda no atacada)
	5:funcion de comprobacion de maximo beneficio


B)MODIFICAR AGENTE
	1:turno colocar reina mandar peticion esperar respuesta
	2:modificar sistema de turno(mirar entorno)
	3:modificar prediucado amenaza
