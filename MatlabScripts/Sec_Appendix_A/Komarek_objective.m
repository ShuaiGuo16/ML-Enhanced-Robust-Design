function [ y ] = Komarek_objective(x, FIR_coef)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Construct objective function to bootstrap Komarek's 
%            coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> x: 1 x 5 row vector, flame parameters of Komarek's model,
%   ===> FIR_coef: target impulse response coefficients (Pre-generated
%            realizations of impulse response)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> y: objective function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Construct the FIR model
N = 70;
delta_t = 2e-4;
h = FIR_coeff_filling(x,N,delta_t);

% Compute the error
e = h - FIR_coef;

% Compute the target
y = sum(e.^2);

