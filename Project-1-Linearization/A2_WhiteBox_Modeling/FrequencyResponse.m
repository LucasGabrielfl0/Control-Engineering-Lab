%% Frequency Analysis
% Analysis of the grey-box system provided in class in the frequency
% domain, Creating it's experimental bode plot and compare with the Model's
clc
clear
s=tf('s');

% Frequency Values tested: ----------------------------------------------
Freq_Hz=   [5e-3        0.1         0.5         0.9         1.2         ...
            1.5         2.0         2.5         3           3.5         10     ]; 

% Gain found for the frequency values in Freq_Hz: ------------------------
K_array=   [1.406       1.406        1.344       1.125      969e-3      ...
            844e-3      719e-3       594e-3      531e-3     469e-3      149e-3  ];


% Phase shift found for the frequency values in Freq_Hz: ------------------
Phase_array= [180       176          157         144        140         ...
              128       123          120         113        112         97    ];


% Gain in db (for the bode plot)
Kdb_array=20*log10(K_array);


%% Experimental Bode Plot:
hold on

% Kdb  -----------------------------------------
subplot(2,1, 1)
semilogx(Freq_Hz,Kdb_array)

title('Bode Diagram')
ylabel('Gain [db]')
grid on

% Phase ---------------------------------------
subplot(2,1, 2)
semilogx(Freq_Hz,Phase_array)
grid on
ylabel('Phase (degree)')
xlabel('Frequency [Hz]')



%% Model Bode plot
% Model's Transfer Function
t=0.1436;  % Time constant
K=1.406;    % Static Gain
Gp=-K/(t*s+1);

%Frequency Range
start_w=(5e-3)/(2*pi);
end_w=95;
W_bode=linspace(start_w, end_w, 10000);
% Model's BODE plot
[mag_bode, phase_bode, wout]=bode(Gp, W_bode);

mag_model=mag_bode(:,1:end);        % Gain in db
phase_model=phase_bode(:,1:end);    % Phase in Degrees
Freq_Hz_Model=wout/(2*pi);          % Frequency in Hz
Kdb_model=20*log10(mag_model);

% MODEL'S Bode: =============================
hold on
% Kdb ---------------------------------------
subplot(2,1, 1)
semilogx(Freq_Hz_Model, Kdb_model)  % Model's Bode (Gain)

grid on
title('Bode Diagram')
ylabel('Kdb')


% Phase ---------------------------------------
subplot(2,1, 2)
semilogx(Freq_Hz_Model, phase_model)

grid on
ylabel('Phase (degree)')
xlabel('Frequency [Hz]')


%% COMPARE BODE
close all

% Compare EXPERIMENTAL Bode and MODEL'S Bode: =============================
hold on
% Kdb ---------------------------------------
subplot(2,1, 1)
semilogx(Freq_Hz,Kdb_array,'o', Freq_Hz_Model, Kdb_model)  % Model's Bode (Gain)

grid on
title('Bode Diagram')
ylabel('Kdb')
legend('Experimental data','Models data', Location='southwest')


% Phase ---------------------------------------
subplot(2,1, 2)
semilogx(Freq_Hz,Phase_array,'o', Freq_Hz_Model, phase_model)

grid on
ylabel('Phase (degree)')
xlabel('Frequency [Hz]')
legend('Experimental Response','Models Response',Location='southwest')
