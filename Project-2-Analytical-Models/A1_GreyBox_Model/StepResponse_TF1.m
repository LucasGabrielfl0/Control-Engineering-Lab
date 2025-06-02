%% STEP RESPONSE TEST
% Create a model and analyse a grey-box system using it's step response 
clc
clear
s=tf('s');

% Parameters measured from experimental Data:
t = 0.165;     % Time constant [sec]
K = -1.406;    % Static Gain   [adm]

% Physical Circuit Estimated Values:
C1 = 330e-9;  % [F]
R2 = t/C1;    % [Ohm]
R1 = -R2/K;   % [Ohm]

% Analytical Transfer Function (Low Pass Filter)
Gp=K/(t*s+1);

[Response_tf, time_tf]= step(Gp,'g');


%% COMPARE (UNITARY) STEP RESPONSE

% Experimental Data:
load("StepResponse_Experimental/Response_exp.mat");
load("StepResponse_Experimental/time_exp.mat");

% Simulink Data
load("StepResponse_Simulink/Response_slink.mat");
load("StepResponse_Simulink/time_slink.mat");


% Plot and Compare
close all
hold on

plot(time_exp   , Response_exp   ,'m'  , LineWidth=1)       % Experimental Response
plot(time_tf    , Response_tf    ,'g'  , LineWidth=1)       % Model Response [Matlab TF]
plot(time_slink , Response_slink ,'--b', LineWidth=2)       % Model Response [Simulink Circuit]


% Plot Config
grid on
legend('Experimental Response','Models response [Simulink]', 'Models response [TF]')
title('Compare Models x Experimental responses')
ylabel('Voltage [V]')
xlabel('Time [sec]')
