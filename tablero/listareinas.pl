listareinas(L):-une(L,Y).
une([],[]).
une(Y,X):-X is listing('queen(X,Y)').
queen(1,2).
queen(2,1).