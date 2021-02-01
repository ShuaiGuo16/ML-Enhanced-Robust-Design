clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Generate Fig. 13 in ref [1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tau_coor = linspace(2,4.8,30);    % Units: ms
R_coor = linspace(0.6,1,30);
[tau, R] = meshgrid(tau_coor,R_coor);   % Units: ms

% Load reference case (A)
load 'ITA_RF.mat'
load 'CAV_RF.mat'
% Load uncorrelated case (B)
Un_ITA=load('Un_ITA_RF.mat')
Un_CAV=load('Un_CAV_RF.mat')
% Load correlated case (C)
Cor_ITA=load('Cor_ITA_RF.mat')
Cor_CAV=load('Cor_CAV_RF.mat')



figure(1)
hold on
% ITA risk
contour(tau,R,ITA_RF,[0.05 0.05],'LineColor','b','ShowText','off','LineWidth',3);
contour(tau,R,Un_ITA.ITA_RF,[0.05 0.05],'LineColor','b','ShowText','off','LineWidth',3);
contour(tau,R,Cor_ITA.ITA_RF,[0.05 0.05],'LineColor','r','ShowText','off','LineWidth',3);
hold off


figure(2)
hold on
% Cavity risk
contour(tau,R,CAV_RF,[0.05 0.05],'LineColor','b','ShowText','off','LineWidth',3);
contour(tau,R,Un_CAV.CAV_RF,[0.05 0.05],'LineColor','b','ShowText','off','LineWidth',3);
contour(tau,R,Cor_CAV.CAV_RF,[0.05 0.05],'LineColor','r','ShowText','off','LineWidth',3);


xlabel('\tau_c/(ms)')
ylabel('R_{out}')
axis([2 4.8 0.6 1])
xticks([2 2.7 3.4 4.1 4.8])
yticks([0.6 0.7 0.8 0.9 1])
h = gca;
h.FontSize = 14;
box on
hold off

