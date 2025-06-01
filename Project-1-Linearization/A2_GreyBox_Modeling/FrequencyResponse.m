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

% Kdb Subplot -----------------------------------------
subplot(2,1, 1)                 % 2 lines, 1 collum, position 1
semilogx(Freq_Hz,Kdb_array)     % Plot in Log Scale

title('Bode Diagram')
ylabel('Gain [db]')
grid on

% Phase Subplot ---------------------------------------
subplot(2,1, 2)                 % 2 lines, 1 collum, position 2
semilogx(Freq_Hz,Phase_array)

grid on
ylabel('Phase (degree)')
xlabel('Frequency [Hz]')


%% Model's Bode plot

% Model's Transfer Function
t  = 0.1436;        % Time constant [sec]
K  = 1.406;         % Static Gain   [adm]
Gp =-K/(t*s+1);     % Analytical Model of the plant

% Frequency Range
start_w = (5e-3)/(2*pi);                    % Plot's Start W
end_w   = 95;                               % Plot's End W
W_bode=linspace(start_w, end_w, 10000);     % W points for the Bode to plot

% Model's BODE plot
[mag_bode, phase_bode, wout] =   bode(Gp, W_bode);

mag_model       = mag_bode(:,1:end);        % Gain [not in db]
phase_model     = phase_bode(:,1:end);      % Phase in Degrees
Freq_Hz_Model   = wout/(2*pi);              % Frequency in Hz

Kdb_model=20*log10(mag_model);              % Gain in db

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
% Compare EXPERIMENTAL Bode and MODEL'S Bode: =============================
close all
hold on

% Kdb Subplot ---------------------------------------
subplot(2,1, 1)
semilogx(Freq_Hz,Kdb_array,'o', Freq_Hz_Model, Kdb_model)  % Model's Bode (Gain)

grid on
title('Bode Diagram')
ylabel('Kdb')
legend('Experimental data','Models data', Location='southwest')


% Phase Subplot---------------------------------------
subplot(2,1, 2)
semilogx(Freq_Hz,Phase_array,'o', Freq_Hz_Model, phase_model)

grid on
ylabel('Phase (degree)')
xlabel('Frequency [Hz]')
legend('Experimental Response','Models Response',Location='southwest')
