 %------------------------------ Questao 8
CR = tf([1 10], [1 6 9 10]);
t=0:0.1:10;
ramp=t;
R1=exp(0.5*t);

%Rampa----------
lsim(CR, ramp, t)

%R1---------------
%lsim(CR, R1, t)
