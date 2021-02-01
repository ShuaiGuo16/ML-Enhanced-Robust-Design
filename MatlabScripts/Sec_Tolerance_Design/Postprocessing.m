clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Post-processing the Pareto front results
%   ===> Generate Fig. 11 in ref [1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load 'results.mat'
tau_std = results(:,1);
R = -results(:,2);
delta_R = 0.9-R;

figure(1)
hold on
plot(tau_std,delta_R,'ko','MarkerFaceColor','k','LineWidth',1.2,'MarkerSize',10)
plot(0.15,0.2,'rp','MarkerFaceColor','r','MarkerSize',12)
axis([0 0.4 0.05 0.25])
h = gca;
h.FontSize = 14;
legend('Pareto Front','Q3')

% fig = gcf;
% fig.PaperPositionMode = 'auto';
% print('Pareto','-dtiff','-r800') 
