%% Sundaresan Method, Under-Damped System ==========================
%Dont run any cell more than once or out of order
clc
clear
s=tf('s');

%Experimental Data
load("Experimental_Data\Atividade1b.mat");
Input_raw= Atividade1_TF2_Entrada.signals.values;
Response_raw= Atividade1_TF2_Saida.signals.values;
time_raw=Atividade1_TF2_Saida.time;

%original Response
plot(time_raw, Response_raw,time_raw, Input_raw)
grid on
legend('Experimental Response', 'Experimental Step')

%% Data Preprocessing 1: Removing Delay
time_Delay=0.099;
delay_index=find(time_raw==time_Delay,1);

% Removing delay (time before step)
Input_exp=Input_raw(delay_index:end);
Response_exp=Response_raw(delay_index:end);

time=time_raw(delay_index:end);
time=time-time_Delay;

plot(time, Response_exp,time, Input_exp)
legend('Preprocessed Response','Preprocessed Step')
grid on

disp('[Data Preprocessing 1]:Delay Removed')


% Delete useless variables
clear Atividade1_TF2_Entrada Atividade1_TF2_Saida
clear du dy delay time_Delay delay_index
clear Input_raw Response_raw time_raw

%% Adjust Responses Gain
du=1;    % Variation in the INPUT
dy=1.5; % Variation in the Reponse

%Make the response unitary (also change the input):
Response_pros=Response_exp/dy;
Input_pros=Input_exp/dy;

% Gain
k=dy/du;

%Plot new unitary gain and it's new input step
One_line=ones(size(Response_pros));

hold on
plot(time,Response_pros, time,Input_pros)
plot(time,One_line)

title('Gain Adjusted')
xlabel('time')
legend('Preprocessed Response','Preprocessed Input','y=1')
grid on

msg=['[Data Preprocessing 2]:Gain Adjusted, k= ', num2str(k)];
disp(msg)

%% Area m1

A1_sqr=1*0.17;                      %B*h
A2_tr=(0.2792 - 0.17)* 0.8  /2;     %B*h/2
A3_tr=(0.3807 - 0.2792)* 0.31 /2;   %B*h/2
A4_tr=(0.4833 - 0.3807)* 0.083 /2;  %B*h/2

m1=A1_sqr - A2_tr + A3_tr - A4_tr;

plot(time,Response_pros,time,One_line)

title("Find m1")
grid on
msg=['[Step 1] m1=', num2str(m1)];
disp(msg)

%% Mi
%Just found the point 0.323 in the graph (solid guess)
Inflex_index=find(Response_pros>0.323,1);
Inflection_Y=Response_pros(Inflex_index);
Inflection_time=time(Inflex_index);

% dy_max=Response_pros(Inflex_index+1)-Response_pros(Inflex_index);
tg_line= [0             1]; % Start Point, Yss=1
tg_time= [0.135      0.1774]; % Start Point time, Yss=1 time

dy=tg_line(2)-tg_line(1);
dt=tg_time(2)-tg_time(1);

% dy=1;
% dt=0.1774- 0.1215;

%Mi = dy/dt (in the inflection point)
Mi=dy/dt;

%Plot the inflection point
hold on

plot(time,Response_pros,time,One_line)      % Response
plot(tg_time,tg_line)                       % Tg Line
scatter(time(Inflex_index), Response_pros(Inflex_index), 'filled')

grid on
title('Inflection Point')
xlabel('Time')
legend('Response', 'y=1', 'Tg line', 'Inflection Point')


msg=['[Step 2] Mi=', num2str(Mi)];
disp(msg)

%% Tm
tm=0.1774;
tm_index=find(Response_pros>1,1);


%Use Scatter to show the Tm point
hold on
plot(time,Response_pros,time,One_line)              % Response
scatter(tm, Response_pros(tm_index), 'filled')      %Tm

title('Time Tm')
xlabel('Time')
legend('Response', 'y=1', 'Tm')
grid on

msg=['[Step 3] tm=', num2str(tm)];
disp(msg)

%% Lambda and zeta
Lambda= Mi*(tm-m1);

%From the graph:
z=0.29;

msg=['[Step 4] lambda= ', num2str(Lambda), ', zeta= ',num2str(z)];
disp(msg)

%% wn and td
wn=acos(z)/( sqrt(1 - z*z) * (tm-m1) );
td= m1 - 2*z/wn;

msg=['[Sundaresan Result] z= ', num2str(z),', wn= ', num2str(wn),', td= ',num2str(td)];
disp(msg)

%% Plot graph
close all %just so we dont plot the other Graphs

% Model Using Sundaresan
Hs_sun= k*( exp(-td*s)*wn*wn )/( s*s+ 2*z*wn*s + wn*wn);


% Plot
hold on
step(Hs_sun, time)                          % Sundaresan [Original]
plot(time, Response_exp, time, Input_exp)   % Experimental Data

title('COMPARING MODEL AND EXMPERIMENTAL STEP')
legend('Model Response', 'Experimental Response', 'Step')
grid on

%% Fine tunning
close all

% Tunned values for Td, Z, Wn:
td_t=0.121;
z_t=0.18;
wn_t=31;

% New Transfer function
Hs_tunned= k*( exp(-td_t*s)*wn_t*wn_t )/( s*s+ 2*z_t*wn_t*s + wn_t*wn_t);

% Plot
hold on
step(Hs_sun, time)                          % Sundaresan [Original]
step(Hs_tunned, time)                       % Sundaresan [Tunned]
plot(time, Response_exp, time, Input_exp)   % Experimental Data

title('COMPARING MODEL AND EXMPERIMENTAL STEP')
legend('Sundaresan [Original]','Sundaresan [Tunned]', 'Experimental', 'Step')
grid on

% Display msg
msg=['[Tunned Result] z= ', num2str(z_t),', wn= ', num2str(wn_t),', td= ',num2str(td_t)];
disp(msg)
