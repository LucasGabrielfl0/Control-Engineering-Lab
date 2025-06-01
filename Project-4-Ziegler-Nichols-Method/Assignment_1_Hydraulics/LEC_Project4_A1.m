%% P4_A1, Control Engineering Laboratory
%Using Ziegler Nichol's method to tune a controller for the 
%plant in the simulink file

clc
clear

%% Plot Model response for different Kp values (Find Kcr)
% Open Simulink just to make sure everything is connected there!
clc
clear

%To find Kcr, theres only Kp
Ki=0;
Kd=0;

%First, Finding Kcr
%For more plot time, change simulation time on Simulink
figure
hold on
for Kp=6:10
    sim('Project_4_Assingment_1');
    t_data=simout.time;
    y_data=simout.signals.values;

    plot(t_data,y_data);
end
grid on
legend('Kp=6', 'Kp=7','Kp=8', 'Kp=9','Kp=10')

%% Parameters based on Ziegler-Nichols Table
% Values found in the previous test
Kcr=10; 
Pcr=117.493e-3; %Found in the previous Plot

%Ziegler-Nichols Table
Kp_z=0.6*Kcr;
Ki_z=1.2*Kcr/Pcr;
Kd_z=0.6*Kcr*Pcr/8;

Kp=Kp_z;
Ki=Ki_z;
Kd=Kd_z;

%% Fine-Tuned Parameters 
%The description of why i choose those is in the slide!
Kp=1.1;
Ki=0.4;
Kd=0.0;

%% Simulate the model and test the control
sim('Project_4_Assingment_1');
hold on

% %get data from the model
t_data=simout.time;
y_data=simout.signals.values;
plot(t_data,y_data);

%PLOT CONFIG ========================================
%Max of 4% Overshoot
max=60.4*ones(size(t_data));

%Settling value is 60 (if ess=0)
Setpoint=60*ones(size(t_data));
Setpoint(1:find(t_data==0.1,1) )=50;
plot(t_data,max,t_data,Setpoint)
grid on
legend('Systems Response','LIMIT','Reference','Location','southeast')


%STEP INFO ========================================
%Already couting with 0.1s simulation time offset
clc
Step_Data=stepinfo(y_data,t_data,60,50);
msgMp=['Mp%: ',num2str(Step_Data.Overshoot),' %'];
msgTs=['Settling Time: ',num2str(Step_Data.SettlingTime-0.1),' s'];
msgTr=['Tr: ',num2str(Step_Data.RiseTime),' s'];
disp(msgMp);
disp(msgTs);
disp(msgTr);

%% COMPARE BEFORE AND AFTER FINE TUNNING 
%BEFORE:================================================================
Kp=Kp_z;
Ki=Ki_z;
Kd=Kd_z;

sim('Project_4_Assingment_1');
figure
hold on
%get data from the model
t_data=simout.time;
y_data=simout.signals.values;
plot(t_data,y_data);

%AFTER:================================================================
Kp=1.1;
Ki=0.4;
Kd=0.0;

sim('Project_4_Assingment_1');
%get data from the model
t_data=simout.time;
y_data=simout.signals.values;
plot(t_data,y_data);

%PLOT CONFIG ========================================
%just for visual aid:
Setpoint=60*ones(size(t_data));
Setpoint(1:find(t_data==0.1,1) )=50;
plot(t_data,Setpoint);

xlabel('Time (s)');
ylabel('Cylinder Displacement (mm)');
title('Step Response')
grid on
legend("Before fine Tunning", "After fine Tunning","Reference") 
