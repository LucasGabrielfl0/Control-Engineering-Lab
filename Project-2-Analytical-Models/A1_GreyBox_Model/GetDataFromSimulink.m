%% Get Data from Simulink, using ToWorkspace Tool
clc
clear

% Run Simulink File
Slink_Circuit=sim('TF1_Circuit.slx');

% Save array
Response_slink = Slink_Circuit.StepResponse.signals.values;
time_slink = Slink_Circuit.StepResponse.time;

% Plot
grid on
plot(time_slink, Response_slink,'b',LineWidth=1)
