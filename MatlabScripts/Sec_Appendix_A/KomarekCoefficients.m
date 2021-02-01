clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Bootstrap the Komarek's coefficients
%   ===> Obtain the covariance matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1-Initial value
flame_initial = [2.85,0.7,3,1.8,3.3]/1000;

% 2-Load data (FIR target)
load 'FIR_coef.mat'

% 3-optimization 
number = size(FIR_coef,1);
Komarek = zeros(number,5);
count = number;

for i = 1:number
    Komarek(i,:) = fminsearch(@(x)Komarek_objective(x,FIR_coef(i,:)),flame_initial);
    count = count-1
end

% Extract covariance
num = size(Komarek,1);
CovKomarek = 1/(num+1)*(Komarek'-mean(Komarek',2))*(Komarek'-mean(Komarek',2))';
CovKomarek(:,3)=[];
CovKomarek(3,:)=[];

% save 'CovKomarek.mat' CovKomarek