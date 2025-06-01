%% Signal Conditioning Circuit
% Input Signal Range:   [?V to ?V]
% Output Signal Range:  [0V to 5V]
Vo= 24;
Vd= 12;
Dc=(Vo-Vd)/Vo;
disp(Dc)

%% 1. Amplifier
R1=1;
R2=1;
out1=R2/R1;

%% 2. Filter
fs= 80e3;
fc= 0.8*fs/2;
Rf_2=1e3;
Cf=1/(2*pi*fc*Rf_2);


%% 3. Offset


%% 4. Protection


