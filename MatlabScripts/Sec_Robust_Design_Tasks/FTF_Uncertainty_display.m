clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Display the uncertainty of Komarek's flame model in
%            frequency domain
%   ===> Generate Fig. 3(b) in ref[1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%   ===> Using Monte Carlo simulation to propagate uncertainties 
%            from parameters of Komarek's flame model to frequency
%            response 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Basic input
N = 60;  % number of coefficients
delta_t = 2e-4;  % sampling interval
uncertainty = 0.1; % 10% uncertainty around the nominal values 
samples=20000;  % Monte Carlo sample number
flame_ref = [2.85,0.7,3,1.8,3.3]/1000; % Nominal parameter values 

% Initialize
h = zeros(N,samples);
X = rand(samples,size(flame_ref,2));

% Specify range
flame_lower = flame_ref-flame_ref*uncertainty;
flame_higher = flame_ref+flame_ref*uncertainty;
flame_lower(3) = 2/1000;  % Consider larger range for tau_c
flame_higher(3) = 4.8/1000;

% Generate random perturbation
flame_random = zeros(samples,size(flame_ref,2));
FIR = zeros(samples,N);
for i = 1:samples
    flame_random(i,:) = (flame_higher-flame_lower).*X(i,:)+flame_lower;
    % Fill in FIR coefficients
    FIR(i,:) = FIR_coeff_filling(flame_random(i,:),N,delta_t);
end

% Translate into FTF
freq = 0:1:500;  % Unit: Hz
FTF = zeros(samples,size(freq,2));
complex_matrix = zeros(N,size(freq,2));

for index_i = 1:N
    for index_j = 1:size(freq,2)
        complex_matrix(index_i,index_j) = exp(-1i*index_i*delta_t*freq(index_j)*2*pi);
    end
end
FTF = FIR*complex_matrix;
mag = abs(FTF);
phase = unwrap(angle(FTF),[],2);

%%%% Post-processing %%%%
figure(1)
% Gain - mean
FIR_ref = FIR_coeff_filling(flame_ref,N,delta_t);
FTF_ref = FIR_ref*complex_matrix;

subplot(2,1,1)
plot(freq,abs(FTF_ref),'k','LineWidth',1.2)
hold on
% Gain - envelope
G_min = zeros(size(freq,2),1);   G_max = zeros(size(freq,2),1);
for i = 1:size(freq,2)
    G_min(i) = min(mag(:,i));
    G_max(i) = max(mag(:,i));
end

plot(freq',G_min,'r--','LineWidth',1)
plot(freq',G_max,'r--','LineWidth',1)
hold off

%%% Plot control %%%%
axis([0 500 -0 2])
xticks(0:100:500)
yticks(0:0.5:2)
h = gca;
h.FontSize = 14;
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Gain','FontSize',14)

%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,1,2)
% Phase - mean
plot(freq',unwrap(angle(FTF_ref)),'k','LineWidth',1.2)
hold on

% Phase - envelope
P_min = zeros(size(freq,2),1);   P_max = zeros(size(freq,2),1);
for i = 1:size(freq,2)
    P_min(i) = min(phase(:,i));
    P_max(i) = max(phase(:,i));
end

plot(freq,P_min,'r--','LineWidth',1)
plot(freq,P_max,'r--','LineWidth',1)
hold off

%%% Plot control %%%%
axis([0 500 -7*pi 0])
xticks(0:100:500)
yticks([ -6*pi -4*pi -2*pi 0])
yticklabels({'-6\pi' '-4\pi' '-2\pi' '0'})
h = gca;
h.FontSize = 14;
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Phase','FontSize',14)
        