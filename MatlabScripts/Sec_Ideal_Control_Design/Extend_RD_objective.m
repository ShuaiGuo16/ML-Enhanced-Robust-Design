function [y] = Extend_RD_objective(tau, X, GP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Construct objective function for task 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> tau: scalar, tau_c
%   ===> X: matrix, samples to calculate risk factor
%   ===> GP: trained GP model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> y: objective function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate constrains
pf = RD_calculator(tau, X, GP);

% Combine constrains with objectives
y = (tau-3)^2+5000*max([pf(1)-0.001,pf(2)-0.001,0]);     % Units: ms

end

