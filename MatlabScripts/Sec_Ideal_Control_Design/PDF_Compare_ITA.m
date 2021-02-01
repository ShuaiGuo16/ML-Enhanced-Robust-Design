clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Perform comprehensive comparison between GP & 
%            reference results (ITA mode)
%   ===> Generate Fig. 9(a) in ref [1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initilization
addpath('./Monte_Carlo_Results')
load 'MC.mat'

%% GP prediction
GP_model = load('GP.mat')
predict_GP = uq_evalModel(GP_model.GP, X);  % UQLab function
% Risk factor calculation
ITA_RF_GP = size(find(predict_GP(:,2)>0),1)/20000

%% Compare the results
% Risk factor calculation
ITA_RF_MC = size(find(Y(:,2)>0),1)/20000

% 2-Joint & Marginal distribution (ITA mode)
figure(1)
%%%%%%%%%%%% Frequency %%%%%%%%%%%%%%%
subplot(2,2,1)
hold on
pts = min(predict_GP(:,1)):0.01:max(predict_GP(:,1));
[f_Pre,xi_Pre] = ksdensity(predict_GP(:,1),pts);
plot(xi_Pre,f_Pre,'k-','LineWidth',2)
H = histogram(Y(:,1),'Normalization','pdf');
hold off

set(H,'FaceColor',[0.75 0.75 0.75]);
xlabel('Frequency (Hz)')
ylabel('PDF')
yticks([0 0.05 0.1 0.15])
axis([120 140 0 0.15])
h = gca;
h.FontSize = 10;
% Calculate r^2 coefficient
r_freq = Coefficient_determination(predict_GP(:,1),Y(:,1))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% growth rate %%%%%%%%%%%%%%%
subplot(2,2,4)
hold on
pts = min(predict_GP(:,2)):0.01:max(predict_GP(:,2));
[f_Pre,xi_Pre] = ksdensity(predict_GP(:,2),pts);
plot(xi_Pre,f_Pre,'k-','LineWidth',2)
H = histogram(Y(:,2),'Normalization','pdf');
plot([0 0], [0 0.025],'r--','LineWidth',1.2)
hold off

set(H,'FaceColor',[0.75 0.75 0.75]);
xlabel('Growth Rate (rad/s)')
ylabel('PDF')
axis([-110 10 0 0.025])
yticks([0 0.005 0.01 0.015 0.02 0.025])
h = gca;
h.FontSize = 10;
% Calculate r^2 coefficient
r_greq = Coefficient_determination(predict_GP(:,2),Y(:,2))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% joint distribution %%%%%%%%%%%%%%%
subplot(2,2,3)
hold on
range = [120 140;-110 10];
interval = [2,6];
[MC_count,X_ITA,Y_ITA] = PDF_Contour2D(Y(:,1:2),range,interval);
max_density_MC = max(max(MC_count));
% Plot MC 2D density - several PDF levels (10%,30%,50%,70%,90%)
contour(X_ITA,Y_ITA,MC_count,'--','LineColor','r','ShowText','off','LevelList',0.1*max_density_MC,'LineWidth',2.5,'LabelSpacing',110)
contour(X_ITA,Y_ITA,MC_count,'--','LineColor','r','ShowText','off','LevelList',0.3*max_density_MC,'LineWidth',2.5,'LabelSpacing',110)
contour(X_ITA,Y_ITA,MC_count,'--','LineColor','r','ShowText','off','LevelList',0.5*max_density_MC,'LineWidth',2.5,'LabelSpacing',110)
contour(X_ITA,Y_ITA,MC_count,'--','LineColor','r','ShowText','off','LevelList',0.7*max_density_MC,'LineWidth',2.5,'LabelSpacing',110)
contour(X_ITA,Y_ITA,MC_count,'--','LineColor','r','ShowText','off','LevelList',0.9*max_density_MC,'LineWidth',2.5,'LabelSpacing',110)
% Plot GP 2D density - several PDF levels (10%,30%,50%,70%,90%)
[GP_count,X_ITA,Y_ITA] = PDF_Contour2D(predict_GP(:,1:2),range,interval);
max_density_GP = max(max(GP_count));
contour(X_ITA,Y_ITA,GP_count,'LineColor','k','ShowText','off','LevelList',0.1*max_density_GP,'LineWidth',1.5,'LabelSpacing',110)
contour(X_ITA,Y_ITA,GP_count,'LineColor','k','ShowText','off','LevelList',0.3*max_density_GP,'LineWidth',1.5,'LabelSpacing',110)
contour(X_ITA,Y_ITA,GP_count,'LineColor','k','ShowText','off','LevelList',0.5*max_density_GP,'LineWidth',1.5,'LabelSpacing',110)
contour(X_ITA,Y_ITA,GP_count,'LineColor','k','ShowText','off','LevelList',0.7*max_density_GP,'LineWidth',1.5,'LabelSpacing',110)
contour(X_ITA,Y_ITA,GP_count,'LineColor','k','ShowText','off','LevelList',0.9*max_density_GP,'LineWidth',1.5,'LabelSpacing',110)

h = gca;
h.FontSize = 10;
h.XLim = range(2,:);
h.YLim = range(1,:);
xlabel('Growth Rate (rad/s)')
ylabel('Frequency (Hz)')
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%