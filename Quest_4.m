%Lista 1:
%Questao 4 ----------------------------------------------------

G1=tf([10], [1 2 10])
G2=tf([5], [1 5])


Gparallel= parallel(G1,G2) %or G1+G2
GSeries=series(G1,G2) %or G1*G2
GClosed_Loop=feedback(G1,G2)