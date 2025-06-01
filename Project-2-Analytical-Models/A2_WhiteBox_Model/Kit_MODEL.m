%% White Box model of Tf2 and Tf3
clc
clear
s=tf('s');

%% Tf2 White Box model
% Circuit Parameters
C3 = 120e-9;
C4 = 33e-9;

R7  = 120e3;
R8  = 47e3;
R11 = 47e3;

% White Box Model:
Zc3 = 1/(C3*s);
Zc4 = 1/(C4*s);

Z1 = R8*(Zc3+R7)/(R8+Zc3+R7);
Z2 = Zc4*R11/(Zc4+R11);

% Final Transfer Function for TF2
Tf2= -Z2/Z1;

% Delete useless variables
clear Z1 Z2 Zc3 Zc4

%% Tf23 (Cascade of Tf2 and Tf3) White box Model
% Circuit Parameters for Tf3
R13= 1e6;
R14= 1e6;

% Final Transfer Function for TF3
Tf3= -R13/R14;

% Tf2 and Tf3, connect in series
Tf_23=Tf2*Tf3;

step(Tf_23)

%% Experimental Data:
Input_Data=readmatrix('Experimental_Data\Tf23_INPUT.csv','DecimalSeparator',',');
Response_Data=readmatrix('Experimental_Data\Tf23_RESPONSE.csv','DecimalSeparator',',');

Input_raw=Input_Data(:,2);
Response_raw=Response_Data(:,2);
time_raw=Response_Data(:,1);

% plot(time_raw, Response_raw, time_raw, Input_raw)

% Remove Time before Step:
Time_Offset=-0.38038;
Offset_Index=find(time_raw==Time_Offset);

Input_exp=Input_raw(Offset_Index: end);
Response_exp=Response_raw(Offset_Index: end);

time=time_raw(Offset_Index: end);
time=time-time(1);

% Remove Offset
Input_exp =Input_exp - Input_exp(1);
Response_exp=Response_exp-Response_exp(1);

% Plot
plot(time, Response_exp, time, Input_exp)
title('Experimental data')
grid on

%% Simulink Circuit data
close all
Slink_Circuit=sim('P2_Kit_Circuit.slx');

% Note: Knowing the input is a unitary step
Response_sim=Slink_Circuit.Tf23_Response.signals.values;
time_sim=Slink_Circuit.Tf23_Response.time;

plot(time_sim, Response_sim)
title('Circuit Reponse on Simulink')
grid on

%% Comparing Model and Experimental Data:
close all

hold on

plot(time, Response_exp,'r')               % Experimental Response
plot(time_sim, Response_sim,'-g')          % Simulink Circuit
step(Tf_23, time);                         % Model's Response

legend('Experimental Response', 'Model Response','Simulink Circuit Response' )
title(' Step Response: Model x Experimental')
grid on
