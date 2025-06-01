%% Preprocess Experimental data:
% Load experimental data (Measured in the Lab)
Input_data=readmatrix("Experimental_Data_raw\INPUT.csv", "DecimalSeparator",",");
Response_data=readmatrix("Experimental_Data_raw\RESPONSE.csv","DecimalSeparator",",");

%% Separate data
Input_raw=Input_data(:,2);
Response_raw=Response_data(:,2);
time_raw=Response_data(:,1);


%% Remove Noise
Response_raw(Response_raw>0)=0;
Input_raw(Input_raw<0)=0;


%% Remove data before the Step
% Reads the array backwards and find the first 0 (Time right before the step Input)
start_index=find(Input_raw==0,1,"last");

%
Response_exp=Response_raw(start_index:end);
Input_exp=Input_raw(start_index:end);

time_exp=time_raw(start_index:end);
time_exp=time_exp-time_exp(1);


%% Plot Raw data
% Plot the processed data 
hold on
plot(time_exp, Response_exp, time_exp,Input_exp);
legend('Response', 'Step')
title('Experimental Step Response')
ylabel('Voltage [V]')
xlabel('Time [s]')
grid on


%% Save Processed Data
folder = 'ProcessedData';
save(fullfile(folder, 'time_exp.mat'), 'time_exp');
save(fullfile(folder, 'Input_exp.mat'), 'Input_exp');
save(fullfile(folder, 'Response_exp.mat'), 'Response_exp');
