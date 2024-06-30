%% Modeling of Aeropendulum
clc
clear

% Voltages [V] Applied on the motor
Voltage_data= cat(2, 0.1 :0.1: 1.0 , 1.2 :0.2: 3);

%Weight measured in the scale [N] associated with those Voltages
Weight_data= [ 0.0055   0.0046  0.0037  0.0083  0.0203  ...
               0.0352   0.0537  0.0731  0.0907  0.1147  ...
               0.1655   0.2247  0.2802  0.3412  0.4124  ...
               0.4817   0.5677  0.6463  0.7194  0.7961];

%% Equation for Thrust
%Thrust is the ammount of force applied by the Aeropendulum's motor 
L1= 9.5e-2;      % [m]
L2= 27.5e-2;     % [m]

Thrust_data=(L1/L2)*Weight_data;

% Plot:
plot(Voltage_data, Thrust_data,'--o')
grid on
xlabel('Voltage  [V]')
ylabel('Thrust [N]')
title('Experimental data of the Aeropendulum')

%% Static Gain [LINEAR]
% Choosing a (almost) linear range and then applying Polyfit

%Choosing (almost) Linear zone
min_Voltage= 1.8;   %Begin of Linear zone
max_Voltage= 3;     %End of Linear zone

Start_Index= find(Voltage_data==min_Voltage);
End_Index  = find(Voltage_data==max_Voltage);

%Polyfits the system in the 'linear zone'
p_Linear=polyfit(Voltage_data(Start_Index:End_Index), Thrust_data(Start_Index:End_Index),1);
Pol_Linear=polyval(p_Linear, Voltage_data);

%Plots Polyfit
hold on
plot(Voltage_data, Thrust_data, 'ob')   % Experimental Data
plot(Voltage_data, Pol_Linear, 'g')     % Linear Model

%Lines to mark the Linear Region
Data_Size=size(Thrust_data);
Linear_Begin= min_Voltage*ones(Data_Size);
Linear_End  = max_Voltage*ones(Data_Size);

%Lines for Linear Region
plot(Linear_Begin, Thrust_data,'--m')
plot(Linear_End  , Thrust_data,'--m')

% Plot:
grid on
xlabel('Voltage  [V]')
ylabel('Thrust [N]')
title('Linear Model')
legend('Real Data', 'Linear Model', ...
       'Linear Upper Limit','Linear Bottom Limit' ...
       ,'Location','southeast')

msg=['[Linear]     Static Gains: [', num2str(p_Linear),']'];
disp(msg)

%% Static Gain [NON-LINEAR]
% Polyfit the whole data
p_Non_Linear=polyfit(Voltage_data, Thrust_data,5);
Pol_Non_Linear=polyval(p_Non_Linear, Voltage_data);

hold on

plot(Voltage_data, Thrust_data,'--og', LineWidth=1)   
plot(Voltage_data, Pol_Non_Linear,'Color','b') 

% Plot:
grid on
xlabel('Voltage  [V]')
ylabel('Thrust [N]')
title('Non-Linear Model')
legend('Real Data', 'Non Linear Model')

msg=['[Non-Linear] Static Gains: [', num2str(p_Non_Linear),']'];
disp(msg)

%% Comparing Models
close all
hold on

plot(Voltage_data, Thrust_data,'ob','LineWidth',1)  % Experimental data
plot(Voltage_data, Pol_Non_Linear,'r')              % Non linear Model
plot(Voltage_data, Pol_Linear, 'g')                 % Linear Model
% plot(Voltage_data(Start_Index:End_Index), Pol_Linear(Start_Index:End_Index), 'g')

%Lines for Linear Region
plot(Linear_Begin, Thrust_data,'--m')
plot(Linear_End  , Thrust_data,'--m')


grid on
xlabel('Voltage  [V]')
ylabel('Thrust [N]')
title('Comparing Models')
legend('Experimental Data', 'Non Linear Model','Linear Model', 'Location','southeast')
