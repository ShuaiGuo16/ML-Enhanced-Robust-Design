function [y] = Multi_RD_objective(x, X, GP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Construct multi-objective functions for task 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> x: 1 x 2 vector, x(1) is tau_std, x(2) is R lower bound
%   ===> X: matrix, samples to calculate risk factor
%   ===> GP: trained GP model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> y: objective functions
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
pf = RD_calculator(x(1), x(2), X, GP);

% Combine constrains with objectives
y = zeros(2,1);
y(1) = -x(1) + 5000*max([pf(1)-0.0008,pf(2)-0.0008,0]);     % Units: ms
y(2) = -x(2) + 5000*max([pf(1)-0.0008,pf(2)-0.0008,0]);

end

