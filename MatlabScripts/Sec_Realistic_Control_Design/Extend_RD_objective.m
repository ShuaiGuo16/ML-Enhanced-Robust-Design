function [y] = Extend_RD_objective(tau_mean, X, GP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Construct objective function for task 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> tau_mean: scalar, tau_c mean
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
pf = RD_calculator(tau_mean, X, GP);

% Combine constrains with objectives
y = (tau_mean-3)^2+2000*max([pf(1)-0.001,pf(2)-0.001,0]);     % Units: ms

end

