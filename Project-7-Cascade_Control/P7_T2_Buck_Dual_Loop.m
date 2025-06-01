%% Task 2: Dual Loop Controler
% 1. Settling time: [1 ms < Ts(5%) < 5 ms]
% 2. No Overshoot
% 3. Steady State Error = 0

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
Kp=0.04;
Ki=43.6;
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
% PI controller:
Kp=1.8;
Ki=10e3;
C1=(Kp*s+Ki)/s;

% Closed Loop Transfer function / Step Response
CLTF_in= feedback(C1*G1,1);
step(CLTF_in)
grid on


% StepInfo Display
data=stepinfo(CLTF_in, "SettlingTimeThreshold",0.05);
Ts_us=(data.SettlingTime)*1e6;
Mp=data.Overshoot;

msg=['[CLTF_in]  Ts: ',num2str(Ts_us),' us || Mp(%): ',num2str(Mp) ... 
    ,'% || Relative Speed: ',num2str(Ts_ms*1e3/Ts_us),'x faster' ];
disp(msg)



%% CASCADE CONTROL
close all

CLTF= feedback(C2*G2*CLTF_in,1);          % External Loop
step(CLTF)
grid on

% StepInfo Display
data=stepinfo(CLTF, "SettlingTimeThreshold",0.05);
Ts_ms=(data.SettlingTime)*1e3;
Mp=data.Overshoot;

msg=['[CLTF]  Ts: ',num2str(Ts_ms),' ms || Mp(%): ',num2str(Mp)];
disp(msg)