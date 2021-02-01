clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Estimate risk maps for task 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 0-Initilize
uqlab

%% 1-GP model training
load 'GP.mat'

%% 2-Load & Generate samples
% Switch between 'MC_uni.mat' (uniform), 'MC_uncor.mat' (uncorrelated Gaussian)
% and 'MC_cor.mat' (correlated Gaussian)
load 'MC_uni.mat'
sample_number = size(X,1);

%% 2-Loop over tau & R to calculate the risk factor
tau_coor = linspace(2,4.8,30);    % Units: ms
R_coor = linspace(0.6,1,30);
[tau, R] = meshgrid(tau_coor,R_coor);   % Units: ms

% initilize matrix
ITA_freq.mean = zeros(size(R));   ITA_freq.std = zeros(size(R));
CAV_freq.mean = zeros(size(R));   CAV_freq.std = zeros(size(R));
ITA_RF = zeros(size(R));          CAV_RF = zeros(size(R));

count = size(tau,1)*size(tau,2);
for index_i = 1:size(tau,1)
    for index_j = 1:size(tau,2)
        
        % Add tau & R
        s_tau = (tau(index_i,index_j)-2)/2.8*ones(sample_number,1);
        s_R = (-R(index_i,index_j)+1)/0.4*ones(sample_number,1);
        enX = [X(:,1:2),s_tau,X(:,3:4),s_R];     % All in [0 1]
        
        % Predictions
        predict = uq_evalModel(GP, enX);
        
        % Processing-growth rate (risk factor)
        ITA_RF(index_i,index_j) = 100*size(find(predict(:,2)>0),1)/sample_number;
        CAV_RF(index_i,index_j) = 100*size(find(predict(:,4)>0),1)/sample_number;
        
        count = count-1
    end
end

%% 3-Post-processing
figure(1)
hold on

title('Risk map for ITA')
contour(tau,R,ITA_RF,'LineColor','k','ShowText','on')
contour(tau,R,ITA_RF,[0.1 0.1],'LineColor','k','ShowText','off','LineWidth',2); 
xlabel('\tau')
ylabel('R')
axis([min(tau_coor) max(tau_coor) min(R_coor) max(R_coor)])
hold off

figure(2)
hold on

title('Risk map for Cavity')
contour(tau,R,CAV_RF,'LineColor','k','ShowText','on')
contour(tau,R,CAV_RF,[0.1 0.1],'LineColor','k','ShowText','off','LineWidth',2); 
xlabel('\tau')
ylabel('R')
axis([min(tau_coor) max(tau_coor) min(R_coor) max(R_coor)])
hold off

save 'Uni_ITA_RF.mat' ITA_RF
save 'Uni_CAV_RF.mat' CAV_RF