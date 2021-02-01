clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Estimate risk map for task 5
%   ===> Generate Fig. 12 in ref [1]
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

%% 2-Generate samples
for ii = 1:4
    Input.Marginals(ii).Type = 'Uniform';
    Input.Marginals(ii).Parameters = [0 1];
end
ParaInput = uq_createInput(Input);  % UQLab function
sample_number = 20000;
% Without tau & R
X = uq_getSample(sample_number,'Halton'); % UQLab function

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
        predict = uq_evalModel(GP, enX);  % UQLab function
        
        % Processing-frequency
        ITA_freq.mean(index_i,index_j) = mean(predict(:,1));
        ITA_freq.std(index_i,index_j) = std(predict(:,1));
        
        CAV_freq.mean(index_i,index_j) = mean(predict(:,3));
        CAV_freq.std(index_i,index_j) = std(predict(:,3));
        
        % Processing-growth rate (risk factor)
        ITA_RF(index_i,index_j) = 100*size(find(predict(:,2)>0),1)/sample_number;
        CAV_RF(index_i,index_j) = 100*size(find(predict(:,4)>0),1)/sample_number;
        
        count = count-1
    end
end

%% 3-Post-processing
figure(1)
hold on

% ITA risk
contour(tau,R,ITA_RF,[1 10 30 50],'LabelSpacing',270,'LineColor','k','ShowText','on','LineWidth',1.8)
contour(tau,R,ITA_RF,[0.05 0.05],'LineColor','k','ShowText','off','LineWidth',4.5); 

% Cavity risk
contour(tau,R,CAV_RF,[1 10 50 90],'--','LabelSpacing',200,'LineColor','b','ShowText','on','LineWidth',1.8)
contour(tau,R,CAV_RF,[0.05 0.05],'LineColor','b','ShowText','off','LineWidth',4.5);

xlabel('\tau_c/(ms)')
ylabel('R_{out}')
axis([2 4.8 0.6 1])
xticks([2 2.7 3.4 4.1 4.8])
yticks([0.6 0.7 0.8 0.9 1])
h = gca;
h.FontSize = 14;
box on
hold off

% save 'ITA_freq.mat' ITA_freq
% save 'CAV_freq.mat' CAV_freq
% save 'ITA_RF.mat' ITA_RF
% save 'CAV_RF.mat' CAV_RF

