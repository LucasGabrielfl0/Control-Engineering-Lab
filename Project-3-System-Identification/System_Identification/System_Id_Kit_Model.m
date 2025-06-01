%% System Identification
%% Importing Experimental Data
% NOTE: Run a section more than once or out of order might cause errors
clc
clear

Input=readmatrix('Experimental_Data\STEP.csv','DecimalSeparator',',');

Response=readmatrix('Experimental_Data\RESPONSE.csv','DecimalSeparator',',');

time=Input(:,1);
Input_exp=Input(:,2);
Response_exp=Response(:,2);


plot(time,Input_exp, time, Response_exp)
title('Experimental data')
legend('Step', 'Response')
grid on

%% 1. Remove Offset
Input_exp=Input_exp+0.03125;
Response_exp=Response_exp+0.03125;

% Also, erase some noise
Response_exp(Response_exp>0)=0;

plot(time,Input_exp, time, Response_exp)
title('Experimental data')
legend('Step', 'Response')
grid on

disp('[Data Preprocessing 1]: Offset Removed')
%% 2. Remove Time before Step
%Start time and End of Response
start_time=-0.06;
end_time=0.03;

start_index = find(time==start_time,1);
end_index = find(time>=end_time,1);

% Remove de time before the step and after steady state
RESPONSE_exp=Response_exp(start_index:end_index);
INPUT_exp=Input_exp(start_index:end_index);

time=time(start_index:end_index);
time=time-time(1);

% Plot
plot(time,INPUT_exp, time, RESPONSE_exp)
title('[Preprocessed] Experimental data')
legend('Step', 'Response')
grid on

disp('[Data Preprocessing 1]: Time before step Removed')
%% Transfer Function from System Id
s=tf('s');
% Original SystemId response
tf1= 2.9334e05*(s-1.484e05)*(s+53.23) / ( (s+628.9)*(s+75.73)*(s*s + 8092*s + 4.868e07) );

% Using Dominance criterium in the fastest zeros/poles ( about 6x faster)
SysId_Model= 2.9334e05*(-1.484e05)*(s+53.23) / ( (s+628.9)*(s+75.73)*(4.868e07) );

disp('[System Id]: Transfer function Generated')
% zpk(SysId_Model)
clear Input_exp Response_exp
%% Compare Model and Experimental Response [Plot]
close all

hold on
plot(time, INPUT_exp,'-r', time, RESPONSE_exp,'m'); % Experimental
step(SysId_Model,'g')                               % Model
step(tf1,'b')
legend('step', 'Experimental response','System Id Model [Tunned]', 'System Id Model' )
grid on