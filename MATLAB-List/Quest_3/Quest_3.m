%Lista 1:
%Questao 3 ----------------------------------------------------
Gs=tf(0.6618, [1 1.0069 0.6618]);
Ginfo=stepinfo(Gs);

syms s
Ys= 0.6618/((s*s)+ 1.0069*s + 0.6618) * (1/s); %fun. transferencia*Degrau

yss=limit(Ys*s,s,0); %Limite usando TVF
y_Regime =sym2poly(yss); %passando de simbolico para numerico

x=['Tempo de Pico: ', num2str(Ginfo.PeakTime) ,'s, Ultrapassagem Percentual: ',num2str(Ginfo.Overshoot),'%, Valor Maximo: ',num2str(Ginfo.Peak),', Valor em Regime Permanente: ',num2str(y_Regime)];
disp(x);
