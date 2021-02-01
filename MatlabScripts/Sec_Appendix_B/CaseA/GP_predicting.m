clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Perform comparison between GP & reference results 
%            case A (uniform)
%   ===> Generate Fig. 14 in ref [1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initilization
addpath('./Monte_Carlo_Results/')
uqlab
for ii = 1:4
    Input.Marginals(ii).Type = 'Uniform';
    Input.Marginals(ii).Parameters = [0 1];
end
ParaInput = uq_createInput(Input);
sample_number = 20000;
X = uq_getSample(sample_number,'Halton');

% Scale tau_c & R
tau_c = 2.2;   scale_tau_c = 1/2.8*(tau_c-2)*ones(sample_number,1);
R = -0.9;    scale_R = 1/0.4*(R+1)*ones(sample_number,1);

% Construct scaled input matrix
en_X = [X(:,1:2), scale_tau_c, X(:,3:4),scale_R];

% GP prediction
GP_model = load('GP.mat')
predict_GP = uq_evalModel(GP_model.GP, en_X);
ITA_RF_GP = size(find(predict_GP(:,2)>0),1)/20000;
CAV_RF_GP = size(find(predict_GP(:,4)>0),1)/20000;
RF_GP = [ITA_RF_GP,CAV_RF_GP]

% Compare the results
load 'MC_uni.mat'
ITA_RF_MC = size(find(Y(:,2)>0),1)/20000;
CAV_RF_MC = size(find(Y(:,4)>0),1)/20000;
FR_MC = [ITA_RF_MC,CAV_RF_MC]

%%%%%%%%%%%%%%%% ITA Growth Rate %%%%%%%%%%%%%%%
figure(1)
hold on
pts = min(predict_GP(:,2)):0.01:max(predict_GP(:,2));
[f_Pre,xi_Pre] = ksdensity(predict_GP(:,2),pts);
plot(xi_Pre,f_Pre,'k-','LineWidth',2)
H = histogram(Y(:,2),'Normalization','pdf');
plot([0 0], [0 0.03],'r--','LineWidth',1.2)
hold off

legend('GP','Reference','Location','northwest')
set(H,'FaceColor',[0.75 0.75 0.75]);
xlabel('Growth Rate (rad/s)')
ylabel('PDF')
h = gca;
h.FontSize = 14;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Cavity Growth Rate %%%%%%%%%%%%%%%
figure(4)
hold on
pts = min(predict_GP(:,4)):0.01:max(predict_GP(:,4));
[f_Pre,xi_Pre] = ksdensity(predict_GP(:,4),pts);
plot(xi_Pre,f_Pre,'k-','LineWidth',2)
H = histogram(Y(:,4),'Normalization','pdf');
plot([0 0], [0 0.03],'r--','LineWidth',1.2)
hold off

legend('GP','Reference','Location','northwest')
set(H,'FaceColor',[0.75 0.75 0.75]);
xlabel('Growth Rate (rad/s)')
ylabel('PDF')
h = gca;
h.FontSize = 14;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%