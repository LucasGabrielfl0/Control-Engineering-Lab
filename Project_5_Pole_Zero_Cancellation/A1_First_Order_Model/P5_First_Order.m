%% Plant and Reference Model
clc
clear
s=tf('s');

%% Plant Model ()
%Op-Amp 1
R1=25e3;
R2=50e3;
C2=330e-9;

Zc=1/(C2*s);
Z1=Zc*R2/(Zc+R2);

ft1=-Z1/R1;

%Op-Amp 2
R3=1e6;
R4=1e6;

ft2=-R4/R3;

Gp=ft1*ft2;

%% Reference Model
Gmr=1/(0.005*s+1);  


%% Controller [Using Reference Model]
%Separate all the Numerators and Denominators
% Reference Model
Nmr=cell2mat(Gmr.Numerator);
Dmr=cell2mat(Gmr.Denominator);
%Plant
No= cell2mat(Gp.Numerator);
Do= cell2mat(Gp.Denominator);

% Multiply Polynomials :)
Gc_Num=conv(Nmr,Do);           % Gc_num=   Nmr*Do
Gc_Den=conv(No, (Dmr-Nmr) );   % Gc_den= No*(Dmr-Nmr)

Gc=tf(Gc_Num,Gc_Den);

%% Plot Graph
CLTF=feedback(Gc*Gp,1);

hold on
step(CLTF,'b');
step(Gmr,'--g');

grid on
legend('Closed Loop response', 'Reference Model Response')
