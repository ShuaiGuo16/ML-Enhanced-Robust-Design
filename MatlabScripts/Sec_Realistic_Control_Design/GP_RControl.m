clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Estimate optimum tau_c for task 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load data
load 'X.mat'  % Pre-generated samples for risk factor calculation
load 'GP.mat'

% Employ pattern search algorithm
options = optimoptions('patternsearch','Display','iter','PlotFcn',@psplotbestf,'MeshTolerance',1e-9,'StepTolerance',1e-9);
x0 = 4;    % Unit: ms
LB = 2;   % Lower bound, Unit: ms
UB = 4.8;  % Upper bound, Unit: ms

[x,fval] = patternsearch(@(tau_mean)Extend_RD_objective(tau_mean, X, GP),x0,[],[],[],[],LB,UB,[],options)