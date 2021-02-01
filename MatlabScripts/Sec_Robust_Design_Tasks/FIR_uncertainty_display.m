clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Display the uncertainty of Komarek's flame model in 
%            time domain
%   ===> Generate Fig. 3(a) in ref[1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%   ===> Using Monte Carlo simulation to propagate uncertainties 
%            from parameters of Komarek's flame model to impulse
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
delta_t = 2e-4; % sampling interval
uncertainty = 0.1; % 10% uncertainty around the nominal values 
samples=20000;  % Monte Carlo sample number
flame_ref = [2.85,0.7,3,1.8,3.3]/1000;  % Nominal parameter values 

% Initialize
h = zeros(N,samples);
X = rand(samples,size(flame_ref,2));

% Specify range
flame_lower = flame_ref-flame_ref*uncertainty;
flame_higher = flame_ref+flame_ref*uncertainty;
flame_lower(3) = 2/1000;    % Consider larger range for tau_c
flame_higher(3) = 4.8/1000;

% Generate random perturbation
flame_random = zeros(samples,size(flame_ref,2));
FIR = zeros(samples,N);
for i = 1:samples
    flame_random(i,:) = (flame_higher-flame_lower).*X(i,:)+flame_lower;
    % Fill in FIR coefficients
    FIR(i,:) = FIR_coeff_filling(flame_random(i,:),N,delta_t);
end

%%%% Post-processing %%%%

% Plot the nominal FIR
figure(1)
FIR_ref = FIR_coeff_filling(flame_ref,N,delta_t);

time1 = delta_t:delta_t:N*delta_t;
stem(time1,FIR_ref,'k','filled','LineWidth',1,'MarkerSize',8)
hold on

% Plot the envelope 
current_min = zeros(N,1);   current_max = zeros(N,1);
count = N;
for i = 1:N
    current_min(i) = min(FIR(:,i));
    current_max(i) = max(FIR(:,i));
end

plot(time1,current_min,'r--','LineWidth',1.2)
plot(time1,current_max,'r--','LineWidth',1.2)
hold off

% Plot control 
axis([0 0.012 -0.1 0.25])
xticks(0:0.003:0.012)
h = gca;
h.FontSize = 14;
xlabel('Time (s)','FontSize',14)
ylabel('Amplitude','FontSize',14)
