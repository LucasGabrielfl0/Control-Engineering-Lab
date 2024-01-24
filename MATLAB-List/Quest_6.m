 %------------------------------ Questao 6
 clc
 clear
 for z= 0 :0.2:1
    Tcr=tf(1, [1 2*z 1]); 
    step(Tcr,30)
    hold on
 end
legend('z=0    (Sem Amortecimento)','z=0.2 (SubAmortecido)', 'z=0.4 (SubAmortecido)', 'z=0.6 (SubAmortecido)', 'z=0.8 (SubAmortecido)', 'z=1    (Criticamente Amortecido)', 'Location','SouthEast')
 