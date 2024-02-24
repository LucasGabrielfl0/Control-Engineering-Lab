%PRATICA 4, Atividade 2
Kcr=8;
Pcr=181.017;

%Parameters based on Ziegler-Nichols Table (PID)
Kp_z=0.6*Kcr;
Ki_z=1.2*Kcr/Pcr;
Kd_z=0.6*Kcr*Pcr/8;

%Parameters based on Ziegler-Nichols Table (PI)
% Kp_z=0.45*Kcr;
% Ki_z=0.54*Kcr/Pcr;
% Kd_z=0;

%Tuned Parameters 
%Using Ziegler-Nichols
% Kp=Kp_z;
% Ki=Ki_z;
% Kd=Kd_z;

%Manual Tuning after Ziegler-Nichols
% Kp=5;
% Ki=1;
% Kd=100;

%Simulate the model and get Data--------------------------------------------
% sim('Pratica6_Atividade3');

%get data from the model
% t_data=simout.time;
% y_data=simout.signals.values;
% stepinfo(y_data,t_data)
% plot(t_data,y_data);
% %----------------------------------------------------------

% Testing System Response for different Kp values =====================================
% figure
% hold on
% for Kp=5:8
%     sim('Pratica6_Atividade3');
%     t_data=simout.time;
%     y_data=simout.signals.values;
% 
%     plot(t_data,y_data);
% end
%Graph Settings:
%xlabel('Time (s)');
% ylabel('Temperature (°C)');
% title('Step Response')
% grid on
% legend("Kp=5","Kp=6","Kp=7","Kp=8")
%---------------------------------------------------------

isBangBang=false; %flag to switch on and off BangBang control

%%COMPARING RESPONSES
%BEFORE AND AFTER TUNNING ========================================
% %BEFORE:
% Kp=Kp_z;
% Ki=Ki_z;
% Kd=Kd_z;

% % FIRST CASE------------------------------
% isCase2=false;
% sim('Pratica6_Atividade3');
% t_data=simout.time;
% y_data=simout.signals.values;
% plot(t_data,y_data);
 
% %SECOND CASE-----------------
% isCase2= true;
% sim('Pratica6_Atividade3');
% t_data=simout.time;
% y_data=simout.signals.values;
% plot(t_data,y_data);

%Plot First ans Second case responses
% % xlabel('Time (s)');
% % ylabel('Average House Temperature (°C)');
% % title('Step Response')
% % grid on
% % legend("First Case", "Second Case")

% %AFTER tunning:---------------------------------------------
Kp=12;
Ki=0;
Kd=110;

figure
hold on
% FIRST CASE------------------------------
isCase2=false;
sim('Pratica6_Atividade3');
t_data=simout.time;
y_data=simout.signals.values;
plot(t_data,y_data);

% stepinfo(y_data,t_data)

%SECOND CASE-----------------
isCase2= true;
sim('Pratica6_Atividade3');
t_data=simout.time;
y_data=simout.signals.values;
plot(t_data,y_data);

%=================================================
% FIRST CASE------------------------------
isCase2=false; %Flag to switch between case 1 and 2
isBangBang=true
sim('Pratica6_Atividade3');
t_data=simout.time;
y_data=simout.signals.values;
plot(t_data,y_data);

%SECOND CASE-----------------
isCase2= true;
sim('Pratica6_Atividade3');
t_data=simout.time;
y_data=simout.signals.values;
plot(t_data,y_data);

%Plot Full comparinson of responses 
xlabel('Time (s)');
ylabel('Average House Temperature (°C)');
title('Step Response')
legend("PID Controller (First case)", "PID Controller (Second case)","On/Off Controller (First case)","On/Off Controller (Second case)")
grid on

% legend("First case Before Tunning", "Second case BeforeTunning","First case After fine Tunning","Second case After fine Tunning")
%========================================================================
