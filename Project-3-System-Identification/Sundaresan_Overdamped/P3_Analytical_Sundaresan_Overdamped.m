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

%% 2. Polyfit the System
%To aply the analytical method, its necessary to polyfit the system first
Input_pol=ones(size(Response_exp)); %for sake of comparison, creates step
Input_pol(1)=0;

%Polyfits response
yp=polyfit(time,Response_exp, 10);
Response_pol=polyval(yp,time);
Response_pol(Response_pol<0)=0; %removes values below 0, if there are any

%Plot the comparison
hold on
plot(time,Response_exp,time,Input_exp)
plot(time,Response_pol,time,Input_pol)
grid on
title("Original system x Polyfit")
legend('Original Response','Original Step', 'Polyfited Response','Polyfited Step',Location='southeast')

disp('[Data Preprocessing 2]:System Polyfited')

%% 3. Adjust Responses Gain
%For Over-damped systems, ymax=yss
dy=max(Response_pol)-0; % dy=yss-yo = ymax-0
du=Input_pol(end)-0;
k=dy/du;

% Adjust gain [To be Unitary]
Response_pol=Response_pol/dy;
Input_pol=Input_pol/dy;

%Plot new unitary gain and it's new input step
plot(time,Response_pol,time,Input_pol)
grid on

msg=['[Data Preprocessing 2]:Gain Adjusted, k= ', num2str(k)];
disp(msg)

%% Sundaresan Method, Over-Damped Systems  =====================================
%% Calculate m1
yt=polyfit(time,Response_pol, 10);

%Limits of integration
Int_begin=0;                                    %From 0
Int_end=time( find(Response_pol>0.999, 1) );    %To the first value above 0.999

% Integral from 0 to steady state point:
yint=polyint(yt);
m1=diff( polyval(yint,[Int_begin Int_end]) );
m1=1*(Int_end)-m1;

% Plot new unitary gain and it's new input step
plot(time,Response_pol, time, polyval(yt,time))
grid on
msg_m1=['[Step 1] m1=', num2str(m1)];
disp(msg_m1)

%% Calculate Mi
% Mi is the slope (dy/dt) in the inflection point

dt=time(2)-time(1);                      % evenly spaced, never changes
dy_array=zeros(numel(Response_pol)-1,1); % initializing empty array nx1

% Creates array for every value of dy= yf-yo
for i=1:1:numel(Response_pol)-1
    dy_array(i)=Response_pol(i+1)-Response_pol(i);
end

% The inflection point has the max first derivate.
dy_Max=max(dy_array);

% Mi value = dy/dt [In the inflection Point]
Mi=dy_Max/dt;

% Complete Overkill (just ploting the inflection point)
Inflex_index=find(dy_array==dy_Max);
Pinf_y=Response_pol(Inflex_index);
Pinf_t=time(Inflex_index);

b=Pinf_y-Mi*Pinf_t;%->b=y(x1)-a*x1;
tg_in=Mi*time+b;

%Plot Graph==============
%Plot tg line from 0 to 1
tg_End_Index=find(tg_in>1, 1);
tg_Begin_Index=find(tg_in>0, 1);
tg_in=tg_in(tg_Begin_Index:tg_End_Index);
tg_time=time(tg_Begin_Index:tg_End_Index);

hold on
plot(time,Response_pol)             % Response
plot(tg_time, tg_in)                % Tangent Line
scatter(Pinf_t, Pinf_y,'filled')    % Inflection Point (Literal point)

title("Finding Mi")
legend('Response', 'Tangent Line', 'Inflection Point','Location','southeast')
grid on

msg_Mi=['[Step 2] Mi=', num2str(Mi)];
disp(msg_Mi)

%% Calculate Tm
%Tm is the Point where Tg line has y=1.
Tm_index=find(tg_in>=1,1,'first');
Tm=tg_time(Tm_index);


%Plot Tm and Inflection Point
hold on
grid on
One_Line=ones(size(time));
plot(tg_time, tg_in)
plot(time,Response_pol,time, One_Line)
scatter(Tm, [tg_in(Tm_index)],'filled')
scatter(Pinf_t,Pinf_y,'filled')

legend('Tg line','Reponse', 'y=1', 'Tm', 'Inflection point')

msg=['[Step 3] Tm=', num2str(Tm)];
disp(msg)

%% Calculate Lambda and n
% Calculates Lambda
Lambda= Mi*(Tm-m1);

% Lambda x Eta equation (as explained in the indexed slide)
n1=linspace(0.01,0.99,1000);
x1=log(n1)./(n1-1);
l1=x1.*exp(-x1);

% Finds corresponding value of Eta for calculated Lambda
n_index=find(l1>=Lambda,1);
n_value=n1(n_index);

% Max value for Lambda [Asymptote]
Lamb_Max=exp(-1);

% Asymptote's Graph
n_x=linspace(0, 0.99,1000);
n_y=Lamb_Max*ones(size(n_x));

% For obvious reasons, n < 1
if Lambda>=Lamb_Max-0.01
    n=0.999;
    Lambda=Lamb_Max; 
end

% Plot Graph
hold on
plot(l1,n1);                    % Lambda x Eta   
plot(n_y,n_x);                  % Horizontal Line
scatter(Lambda,n,'filled','g')  % Point

title('Finding value of \eta ')
legend(' values of \eta ','Asymptote', 'Point',Location='northwest')
xlabel('\lambda')
ylabel('\eta')
grid on


msg=['[Step 4] lambda= ', num2str(Lambda), ', n= ',num2str(n)];
disp(msg)

%% Calculating t1,t2,td and ploting the graph:
close all

% Calculating Times t1,t2
t1=( n^( n/(1-n) ) )/Mi;
t2=( n^( 1/(1-n) ) )/Mi;

%Calculating delay time td
td=m1-t1-t2;

% Calculating Models Transfer Function (Hs_ud)
Hs_sun=k*( exp(-td*s) )/( (t1*s+1)*(t2*s+1) );

%Comparing
hold on
plot(time, Input_exp,time, Response_exp); % Experimental Unitary step
step(Hs_sun,time)                         % Model's Step

title('Comparing Model and Experimental Response')
legend('Step', 'Experimental', 'Model', 'location','southeast')
grid on

%Message
msg=['[Sundaresan Result] t1= ', num2str(t1), ', t2= ',num2str(t2), ', td= ',num2str(td)];
disp(msg)

%% Fine tunning
t1_f=1.3;
t2_f=1.2;
td_f=0.4;

% Calculating Models Transfer Function with new values
Hs_tunned=k*( exp(-td_f*s) )/( (t1_f*s+1)*(t2_f*s+1) );

close all

%Plot
hold on
step(Hs_sun,10);            % Sundaresan
step(Hs_tunned,10);         % Sundaresan [Tunned]
plot(time, Response_exp);   % Experimental
plot(time, One_Line);       % Unitary Step

legend('Sundaresan','Sundaresan [Tunned]', 'Experimental','Step', 'Location','southeast')
title('Comparing Step Response')
grid on

%Message
msg=['[Tunned Result] t1= ', num2str(t1_f), ', t2= ',num2str(t2_f), ', td= ',num2str(td_f)];
disp(msg)
