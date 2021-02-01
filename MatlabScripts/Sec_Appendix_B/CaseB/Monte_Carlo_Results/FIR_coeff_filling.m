function [ h ] = FIR_coeff_filling(parameters,N,delta_t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Construct Komarek's distributed time lag flame model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> parameters: 1 x 5 row vector, flame parameters of Komarek's model,
%   with the following order: tau_1, sigma_1, tau_c, tau_s1, tau_s2  (unit: s),
%   see Fig 2 in ref[1] for detailed illustration
%   ===> N: scalar, number of impulse response coefficients
%   ===> delta_t: scalar, sampling interval of impulse response (unit: s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> h: 1 x N row vector, impulse response coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert to Komarek's model structure
time_delay = [parameters(1), parameters(3)+parameters(4), parameters(3)+parameters(5)];
spread = [parameters(2), parameters(4)/3, parameters(5)/3];
% Construct impulse response model
index = 1:N;
h = 1/(spread(1)*sqrt(2*pi))*exp(-0.5*(index*delta_t-time_delay(1)).^2/spread(1)^2)+...
    1/(spread(2)*sqrt(2*pi))*exp(-0.5*(index*delta_t-time_delay(2)).^2/spread(2)^2)-...
    1/(spread(3)*sqrt(2*pi))*exp(-0.5*(index*delta_t-time_delay(3)).^2/spread(3)^2);
h = h*delta_t;

end

