%Lista 1:
%Questao 10 ----------------------------------------------------
k=10.8e8;
a=1;
b=8;
J=10.8e8;
J20=J*0.8;
J50=J*0.5;

Gcontrol= tf([k k*a], [1 b]);
Gmodel= tf(1, [J 0 0]);
Ts= feedback(Gcontrol*Gmodel, 1);
config= RespConfig('Amplitude',10);
step(Ts, config)
hold on

%system response after J was reduced on 20% of the inicial value
Gmodel= tf(1, [J20 0 0]);
Ts= feedback(Gcontrol*Gmodel, 1);
step(Ts, config)

% system responde after J was reduced 50% of the inicial value
Gmodel= tf(1, [J50 0 0]);
Ts= feedback(Gcontrol*Gmodel, 1);
step(Ts, config)
legend('J original','J Reduzido em 20%', 'J Reduzido em 50%', 'Location','SouthEast')
 
%Reduzir J acarretou em uma melhora do sistema, tendo uma clara reducao de
%sobressinal, tempo de pico, tempo de assentamento a medida que o valor de
%J diminui, sem alterar o tipo de sinal (Subamortecido)
