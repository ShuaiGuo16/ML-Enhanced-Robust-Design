clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Estimate Pareto front for task 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initial UQLab
uqlab

% Load data
load 'X.mat'
load 'GP.mat'

% Employ multi-objective genetic algorithm
options = optimoptions('gamultiobj','PlotFcn',@gaplotpareto,'Display','iter');
LB = [0.03 -0.9];   % Lower bound
UB = [0.4 -0.6];  % Upper bound

results = gamultiobj(@(x)Multi_RD_objective(x, X, GP),2,[],[],[],[],LB,UB,[],options)
save 'results.mat' results

figure(1)
plot(results(:,1),results(:,2),'*')
xlabel('\sigma_{\tau}')
ylabel('R')



