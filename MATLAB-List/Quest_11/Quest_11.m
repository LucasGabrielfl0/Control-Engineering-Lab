 %------------------------------ Questao 11
 g1=tf(12.5, [1 1]);
 g2=tf(1 , [1 0]);
 
 for k=0.1 :0.1:0.5
    Fd1= feedback(g1,k);
    T1=Fd1*g2;
    Trc= feedback(T1,1);
    step(Trc)
    hold on
 end
legend('k=0.1', 'k=0.2', 'k=0.3', 'k=0.4', 'k=0.5', 'Location','SouthEast')
