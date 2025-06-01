%% DC Motor Transfer Function
% clc
s=tf('s');

La_m=0.01;    % [H]
Ra_m=3.38;    % [Ohm]
Km_m=0.029;   % [adm]
Jm_m=0.0002;  % [N*m^2]

%% White Box Model

% ft_Ia =[Va-Ea]/Ia
ft_Ia=1/(Ra_m+s*La_m);

% ft_Wm =[Tm-Tc]/Wm
ft_Wm= 1/(s*Jm_m);

% CLTF_w= Wm(s)/Va(s)
CLTF_w=feedback(ft_Ia*Km_m*ft_Wm, Km_m);
CLTF_Rpm=CLTF_w*60/(2*pi);
% Gain=329.2960;

step(CLTF_Rpm);
% zpk(CLTF_Rpm)

%% Grey Box Model
t=14.737e-3;
K=0.2944;

Ra_1=1/K;
La_1=t*Ra_1;
