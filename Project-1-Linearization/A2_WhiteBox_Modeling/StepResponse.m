%% STEP RESPONSE TEST
% Create a model and analyse a grey-box system using it's step response 
clc
clear
s=tf('s');

% Parameters measured from experimental Data:
t = 0.165;     % Time constant [sec]
K = -1.406;    % Static Gain   [adm]

% Physical Circuit Values:
C1 = 330e-9;  % [F]
R2 = t/C1;    % [Ohm]
R1 = -R2/K;   % [Ohm]

% Analytical Transfer Function (Low Pass Filter)
Gp=K/(t*s+1);

step(Gp)
grid on

%% COMPARE (UNITARY) STEP RESPONSE

% Processed Experimental Data:
load("ProcessedData/Response_exp.mat");
load("ProcessedData/time_exp.mat");

% Plot and Compare
close all
hold on

plot(time_exp, Response_exp,'m',LineWidth=1)                % Experimental Response
step(Gp,'g')                                                % Our Model's Response

% Plot Config
grid on
legend('Models response', 'Experimental Response')
title('Compare Model x Experimental responses')
xlabel('Voltage [V]')
ylabel('Time [sec]')

