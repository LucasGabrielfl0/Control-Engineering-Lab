%% STEP RESPONSE TEST
% Model and analyse a grey-box system using it's step response 
clc
clear
s=tf('s');

%Experimental Data:
t=0.165;     % Time constant
K=-1.406;    % Static Gain


%Physical Circuit Values:
C1=330e-9;  % [F]
R2=t/C1;    % [Ohm]
R1=-R2/K;   % [Ohm]
Gp=K/(t*s+1);

step(Gp)
grid on

%% Preprocess Experimental data:
% Load experimental data (Measured in the lab)
Input_data=readmatrix("Experimental_Data\INPUT.csv", "DecimalSeparator",",");
Response_data=readmatrix("Experimental_Data\RESPONSE.csv","DecimalSeparator",",");

% Separate data
Input_raw=Input_data(:,2);
Response_raw=Response_data(:,2);
time_raw=Response_data(:,1);

% Remove Noise
Response_raw(Response_raw>0)=0;
Input_raw(Input_raw<0)=0;

% Remove data before the Step
% Reads the array backwards and find the first 0
% its the last one reading foward, index of the time before the step
start_index=find(Input_raw==0,1,"last");

Response_exp=Response_raw(start_index:end);
Input_exp=Input_raw(start_index:end);

time_exp=time_raw(start_index:end);
time_exp=time_exp-time_exp(1);

% Plot the processed data 
hold on
plot(time_exp, Response_exp, time_exp,Input_exp);
legend('Response', 'Step')
title('Experimental Step Response')
ylabel('Voltage [V]')
xlabel('Time [s]')
grid on


%% COMPARE (UNITARY) STEP RESPONSE
%Experimental response
close all

% Curve for the Step (for reference)
Step_Line=ones( size(time_exp) );
Step_Line(1)=0; %step starts at 0

hold on

step(Gp)                                % Model's Response
plot(time_exp, Response_exp)            % Experimental Response

plot(time_exp, Step_Line, LineWidth=2)       % Unitary Step

% Plot Config
grid on
legend('Models response', 'Experimental Response')
title('Compare Model x Experimental responses')
