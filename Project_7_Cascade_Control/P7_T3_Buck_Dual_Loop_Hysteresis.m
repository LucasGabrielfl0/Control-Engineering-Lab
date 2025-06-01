%% Task 3: Dual Loop Controler [But way faster]
% 1. Settling time: [0.1 ms < Ts(5%) < 1 ms]
% 2. No Overshoot
clc
clear

s=tf('s');

%% Plant (Buck Converter)
Vg= 250;    % Voltage [V]
L=2e-3;     % Inductance [H]
C=30e-6;    % Capacitance [F]
R=30;       % Resistance [Ohm]
fs=10e3;    % Samplying frequency [Hz]

G1= Vg*( C*s + (1/R) ) / ( (L*C*s*s)+  (L/R)*s + 1 );   % Current Control
G2= (R) / ( (R*C*s) + 1 );                              % Voltage Control

%% External Loop [Voltage Control]
% PI controller:
Kp=0.188;
Ki=208;
C2=(Kp*s+Ki)/s;

% Closed Loop Transfer function / Step Response
CLTF_ex= feedback(C2*G2,1);
step(CLTF_ex)
grid on

% StepInfo Display
data=stepinfo(CLTF_ex, "SettlingTimeThreshold",0.05);
Ts_ms=(data.SettlingTime)*1e3;
Mp=data.Overshoot;

msg=['[CLTF_ex]  Ts: ',num2str(Ts_ms),' ms || Mp(%): ',num2str(Mp)];
disp(msg)

%% Internal Loop [Current Control]
% Hysteresis Controller, done on the Simulink File

