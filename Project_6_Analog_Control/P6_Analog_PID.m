%% P6: Controller for a analog PI
% Build a analog circuit of a PI controller to
% control the simulated plant's response

clc
clear

s=tf('s');

%% Experimental Data Preprocessing
% Plant's Step Response (Experimental, Lab)
Plant_exp_Input_DATA=readmatrix('Plant_Data/PURE_PLANT_INPUT_DATA.csv',"DecimalSeparator",",");
Plant_exp_Response_DATA=readmatrix('Plant_Data/PURE_PLANT_OUTPUT_DATA.csv',"DecimalSeparator",",");

Response_raw = Plant_exp_Response_DATA(:,2);
Input_raw    = Plant_exp_Input_DATA(:,2);
time_raw     = Plant_exp_Response_DATA(:,1);

% Remoing Offset from Data (0.1056 was found in the plot)
Offset_time=0.1056;
Offset_Index= find(time_raw>=Offset_time,1);

Response_exp=Response_raw(Offset_Index:end);
Input_exp=Input_raw(Offset_Index:end);
time_exp=time_raw(Offset_Index:end) - Offset_time;

hold on
plot(time_raw, Response_raw, time_raw, Input_raw)
plot(time_exp, Response_exp, time_exp, Input_exp)
grid on

legend( 'Reponse with Offset'   , 'Input with Offset', ...
        'Reponse without Offset', 'Input without Offset','Location','southwest')


%% Plant's Model validation
% compare the step response of the Mathematical model and the
% experimental circuit

% Plants's Step Response (Simulated) [plant=Tf13]
Tf13=1.391/(0.09375*s+1);
[Response_sim, time_sim]=step(Tf13,0.9);
step_sim=ones(size(Response_exp)); %Reference line
step_sim(1)=0;

% Plot Comparison:
plot(time_sim, Response_sim,time_exp, Response_exp)
hold on
plot( time_exp,step_sim,"--") %step, for reference
grid on
legend("Simulated Response","Experimental Response","Step",'Location','southwest')


%% PI Controller Project
% The intuition behind the controller can be found in the slides 

%Zero location == -Z
z=15;

%PI parameters
Kp = 22;
Ki = z*Kp; % since z=Ki/Kp

% Root Locus Method:
Tf_Gc=(s+z)/s;
ftma=Tf_Gc*Tf13;
% rlocus(ftma)

Tf_Control=(s+z)*Kp/s;
% zpk(Tf_Control)


cltf= feedback(Tf_Control*Tf13,1);
step(cltf,0.3);
grid on

% Display:
cltf_Data=stepinfo(cltf);
Ts=cltf_Data.SettlingTime;
Mp=cltf_Data.Overshoot;

msg=['[CLOSED LOOP RESPONSE] Ts: ',num2str(Ts), 's || ', 'Mp%: ',num2str(Mp),'%.'];
disp(msg)

%% Numerator and Denominator of the Transfer Function block at Simulink
% Sends the current Controller transfer function to the 

Tf_Control_num=cell2mat(Tf_Control.Numerator);
Tf_Control_den=cell2mat(Tf_Control.Denominator);

%% Testing Static gain = 1.0 (0 dB) for low frequencies
%Besides the obvious s=0, you can also use the bode plot
% h=bodeplot(cltf);
% grid on

%% Values for Eletronic Parameters
% Values for the Resistors and Capacitors used in the simulink
% to create a PI analog controller with the same transfer function used
% above

% Feedback op-amp resistors
Rfd=5e3;

% Pi circuit
R1= 1e3;
R3= 10e3;
R4= 3.3e3;
C2=1e-6; 

%a=R4/(R3*R1), assuring that R4, R3 and R1 values match calculated 'a'
% It may seem confusing, but it just assures that the values have the right
% proporcion

a=Ki*C2;
a_fis=R4/(R3*R1);

R2= Kp/a;


%% Open Loop(without controller) and Closed Loop Comparison ====================
[y_cl, t_cl]=step(cltf,0.9); % Closed Loop
[y_ol, t_ol]=step(Tf13,0.9); % Open Loop

plot(t_cl, y_cl,t_ol, y_ol)
hold on

%step
plot( t_cl,ones(size(t_cl)),"--")
grid on
legend("Closed Loop Response","Open Loop Response", 'Step','Location','southeast')
title('Before and After Closed Loop control')
