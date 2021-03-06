function [Pf] = RD_calculator(tau_mean, X, GP)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Calculate risk factor given tau_c mean value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> tau_mean: scalar, tau_c mean
%   ===> X: matrix, samples to calculate risk factor
%   ===> GP: trained GP model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> Pf: 1 x 2 vector, risk factor for both modes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1-Prepare
sample_num = size(X,1);

% 2-Generate tau samples
tau_st = 0.05*3;
tau = normrnd(tau_mean,tau_st,[sample_num,1]);   % ms
scale_tau_c = 1/2.8*(tau-2);    


% 3-Expand MC samples
en_X = [X(:,1:2),scale_tau_c,X(:,3:end)];

% 4-Perform MC
predict_GP = uq_evalModel(GP, en_X);  % UQLab function

% 5-Retrive risk factor
ITA_RF = size(find(predict_GP(:,2)>0),1)/sample_num;
CAV_RF = size(find(predict_GP(:,4)>0),1)/sample_num;
Pf = [ITA_RF, CAV_RF];

end

