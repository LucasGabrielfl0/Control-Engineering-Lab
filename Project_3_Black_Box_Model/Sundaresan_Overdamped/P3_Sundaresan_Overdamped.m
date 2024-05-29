%% Sundaresan Method, Over-Damped System ==========================
% IMPORTANT NOTES:--------------------------------
% 1. To see the end result, you can just click 'Run' (Instead of going cell by cell)
% 2. Run cells out of order or run the same consecutive times may cause errors
clc
clear
s=tf('s');

 %Experimental Data Acquired in the Lab
load("Experimental_Data\Atividade1a.mat");

%Systems experimental Input (Step)
Input_exp=Atividade1_TF1_Entrada.signals.values;

%Systems experimental Output (Response)
Response_exp=Atividade1_TF1_Saida.signals.values;

%Time
time=Atividade1_TF1_Saida.time;

plot(time,Response_exp,time,Input_exp)
grid on
title("Experimental Response")

%% 1. Remove Inputs delay
%Find Inputs Delay time
Delay_Index=find(Input_exp<0.5,1,'last');

%Erase the values Before delay
Response_exp=Response_exp(Delay_Index:end);
Input_exp=Input_exp(Delay_Index:end);

%Erases the Delay itself and the Values Before Delay
time=time-time(Delay_Index);
time= time(Delay_Index:end);

plot(time,Response_exp,time,Input_exp)
title("Preprocessed system")
grid on
disp('[Data Preprocessing 1]:Delay Removed')

% Delete extra variables
clear Atividade1_TF1_Entrada
clear Atividade1_TF1_Saida
clear Delay_Index

%% 2. Adjust Responses Gain
%For Over-damped systems, ymax=yss
dy= 1.68; %dy=yss-yo
du= 1;
k=dy/du;

% Adjust gain
Response_pros=Response_exp/dy;
Input_pros=Input_exp/dy;

%Plot new unitary gain and it's new input step
One_Line=ones(size(time)); % Line y=1

hold on

plot(time,One_Line)
plot(time,Response_pros,time,Input_pros)    
title("Gain Adjusted")
grid on

msg=['[Data Preprocessing 2]:Gain Adjusted, K= ', num2str(k)];
disp(msg)

clear dy du
%% Area m1
% Areas
A1=1*1;             %A_Square:   B*h
A2=(4.5-1)*1/2;     %A_Triangle: B*h/2

m1=A1+A2;

%Plot
plot(time,Response_pros,time,One_Line)
title("Area m1")
grid on

msg=['[Step 1] m1=', num2str(m1)];
disp(msg)

clear A1 A2
%% Mi
tg_line= [0             1]; % Start Point, Yss=1
tg_time= [0.81      4.178]; % Start Point time, Yss=1 time


dy=tg_line(2)-tg_line(1);
dt=tg_time(2)-tg_time(1);

Mi=dy/dt;

% Inflection Point:
Inflex_y=0.524193;
Inflex_t=2.581;


%Plot
hold on

scatter(tg_time,tg_line,'filled')
scatter(Inflex_t, Inflex_y,'filled')

plot(tg_time,tg_line)                  % Tg Line
plot(time,Response_pros,time,One_Line,'r')  % Response Signal

title("Slope Mi")
xlabel('Time')
legend('edges', 'Inflection point','Tg', 'Response','y=1', 'location','southeast')
grid on


msg=['[Step 2] Mi=', num2str(Mi)];
disp(msg)

clear dt dy Inflex_t Inflex_y

%% Tm
Tm=tg_time(2);

hold on
plot(tg_time,tg_line)                  % Tg Line
plot(time,Response_pros,time,One_Line)  % Response Signal
scatter(Tm,1,'filled')                  % Tm

title("Time Tm")
xlabel('Time')
legend('Tg', 'Response','y=1', 'Tm')
grid on

msg=['[Step 3] Tm=', num2str(Tm)];
disp(msg)

%% Lambad and n
Lambda= Mi*(Tm-m1);
n=0.99;


msg=['[Step 4] lambda= ', num2str(Lambda), ', n= ',num2str(n)];
disp(msg)

%% Calculate final parameters (t1, t2, td)
close all
% Mi=0.27;
% Calculating Times t1,t2
t1=( n^( n/(1-n) ) )/Mi;
t2=( n^( 1/(1-n) ) )/Mi;

%Calculating delay time td
td=m1-t1-t2;

% Calculating Models Transfer Function (Hs_ud)
Hs_sun=k*( exp(-td*s) )/( (t1*s+1)*(t2*s+1) );

% Plot graphs
hold on
step(Hs_sun,10);                                % Sundaresan [Empiric]
plot(time, Response_exp, time, Input_exp);      % Experimental + Step

grid on
title('Comparing Model and Experimental Response')
legend('Sundaresan [Empiric]', 'Experimental', 'Step', 'Location','southeast')

%Message
msg=['[Sundaresan Result] t1= ', num2str(t1), ', t2= ',num2str(t2), ', td= ',num2str(td)];
disp(msg)

%% Compare

%Analtical values of t1, t2, td
t1_f=1.3015;
t2_f=1.1714;
td_f=0.23266;

% Calculating Models Transfer Function
Hs_An=k*( exp(-td_f*s) )/( (t1_f*s+1)*(t2_f*s+1) );

% Fined tunned values of t1, t2, td
t1_f=1.3;
t2_f=1.2;
td_f=0.4;

% Calculating Models Transfer Function
Hs_tunned=k*( exp(-td_f*s) )/( (t1_f*s+1)*(t2_f*s+1) );

close all

% Plot
hold on

step(Hs_sun,10);            % Sundaresan [Empiric]
step(Hs_An,10);             % Sundaresan [Analytical]
step(Hs_tunned,10);         % Sundaresan [Tunned]
plot(time, Response_exp);   % Experimental
plot(time, One_Line);       % Step

legend('Sundaresan [Empiric]','Sundaresan [Analytical]','Sundaresan [Tunned]', ...
    'Experimental','Step', 'Location','southeast')
title('Comparing Step Response')
grid on

%Message
msg=['[Tunned Result] t1= ', num2str(t1_f), ', t2= ',num2str(t2_f), ', td= ',num2str(td_f)];
disp(msg)
