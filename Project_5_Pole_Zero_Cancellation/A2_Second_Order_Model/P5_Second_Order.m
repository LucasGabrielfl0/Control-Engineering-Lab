%% Pole-Zero Cancellation (A2)
% Plant and Reference Model
% Reference Model is a second Order system
clc
% clear
s=tf('s');

%% Plant's Model
%First Part of the circuit
R4_c=50e3;
R8_c=100e3;
C1_c=330e-9;
C4_c=330e-9;

Z1= R4_c;
Z2= R8_c;
Z3=1/(C1_c*s);
Z4=1/(C4_c*s);

Circ_1= Z3*Z4/( Z1*(Z2+Z4) + Z4*(Z3+Z2) );

%------------------------------
%Second part of the circuit
C5_c= 330e-9;
C6_c= 330e-9;
R11_c= 100e3;
R5_c= 50e3;

Z1=1/(C5_c*s);
Z2=1/(C6_c*s);
Z3=R11_c;
Z4=R5_c;
Circ_2= Z3*Z4/( Z1*(Z2+Z4) + Z4*(Z3+Z2) );

Gp=Circ_1*Circ_2;
zpk(Gp)

%% Reference Model
Gmr=1/(0.00025*s*s + 0.055*s + 1);

%% Controller [Using Reference Model]
%Separate all the Numerators and Denominators
Nmr=cell2mat(Gmr.Numerator);
Dmr=cell2mat(Gmr.Denominator);
No= cell2mat(Gp.Numerator);
Do= cell2mat(Gp.Denominator);

% Multiply Polynomials :)
Gc_Num=conv(Nmr,Do);
Gc_Den=conv(No, (Dmr-Nmr) );

Gc=tf(Gc_Num,Gc_Den);
zpk(Gc)

%% Plot Graph
CLTF=feedback(Gc*Gp,1);

hold on
step(CLTF,'g');
step(Gmr,'--b');

grid on
legend('Closed Loop response', 'Reference Model Response')
