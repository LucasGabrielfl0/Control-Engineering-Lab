%% Task 1: Single Loop Control
% 1. Settling time: [1 ms < Ts(5%) < 5 ms]
% 2. Steady State Error = 0
clc
clear

s=tf('s');

% Plant (Buck Converter)
Vg= 250;    % Voltage [V]
L=2e-3;     % Inductance [H]
C=30e-6;    % Capacitance [F]
R=30;       % Resistance [Ohm]
fs=10e3;    % Samplying frequency [Hz]

G1= Vg / ( (L*C*s*s)+  (L/R)*s + 1 );


%% Controller
Kp = 0.0075;
Ki = 14;
Kd = 0.8e-06;
Tf = 8.18e-06;

% Controller (PIDF)
C1_sl=(Kp)+ Ki/s + Kd*s/(Tf*s+1);

% CLTF:
CLTF=feedback(G1*C1_sl,1);              % Closed Loop Response
Control_Signal = feedback(C1_sl, G1);   % Control Signal [Duty Cycle]


% Plot:
hold on
step(6*Control_Signal)
step(6*CLTF)

grid on
legend('Duty Cycle', 'Response')

% StepInfo Display
data=stepinfo(CLTF, "SettlingTimeThreshold",0.05);
Ts_ms=(data.SettlingTime)*1e3;
Mp=data.Overshoot;

% Message
msg=['[CLTF]  Ts: ',num2str(Ts_ms),' ms || Mp(%): ',num2str(Mp)];
disp(msg)