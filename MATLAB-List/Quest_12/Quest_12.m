 %------------------------------ Questao 12
 g1= tf(1, [1 1]);
 g2= tf([1 0], [1 0 2]);
 g3= tf([4 2],[1 2 1]);
 Fd1 = feedback(g1*g2,g3);

 g4=tf(1 ,[1 0 0]);
 g5=50;
 Fd2= feedback(g4,g5,+1);
 
 g6= tf([1 0 2], [1 0 0 14]);
 Fd3 =feedback(Fd1*Fd2,g6);
 
 Try =4*Fd3;
 [num, den] =tfdata(Try);
 num=cell2mat(num);
 den =cell2mat(den);
 
 pzmap(Try)
 Pol_r= roots(den);
 zer_r=roots(num);

 %eh possivel observar que devido aos polos no semiplano direito, o sistema
 %eh obviamente instavel