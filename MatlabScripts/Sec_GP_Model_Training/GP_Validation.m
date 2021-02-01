clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Assess the accuracy of the trained GP models
%   ===> Generate Fig. 6 & 7 in ref[1]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 0-Initial
load 'training.mat'
sample_number = 18;
iteration_number = (size(training.Y,1)-sample_number)/6+1;

%% 1-Check error history
load 'errITA.mat'
load 'errCav.mat'
load 'GP.mat'
iteration = size(errITA.fref,1);
target_iter = 8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
hold on

scale_1 = var(GP.ExpDesign.Y(:,1));
plot(1:iteration,errITA.fref/scale_1,'ko-','LineWidth',1.2)

scale_2 = var(GP.ExpDesign.Y(:,2));
plot(1:iteration,errITA.gref/scale_2,'k>--','LineWidth',1.2)
hold off

h = gca;
h.FontSize = 14;
xlabel('Iteration','FontSize',14)
ylabel('Relative Error','FontSize',14)
legend('Frequency','Growth Rate')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
hold on

scale_3 = var(GP.ExpDesign.Y(:,3));
plot(1:iteration,errCav.fref/scale_3,'ko-','LineWidth',1.2)

scale_4 = var(GP.ExpDesign.Y(:,4));
plot(1:iteration,errCav.gref/scale_4,'k>--','LineWidth',1.2)
hold off

h = gca;
h.FontSize = 14;
xlabel('Iteration','FontSize',14)
ylabel('Relative Error','FontSize',14)
legend('Frequency','Growth Rate')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load 'predict_test.mat'
load 'testing.mat'

figure(3)
subplot(2,2,1)
hold on
GP_predict_ITA_fref = predict_test(1:50,end-3);
plot(GP_predict_ITA_fref,testing.Y(1:50,1),'ko','LineWidth',1.2,'MarkerSize',8)
plot([100 180], [100 180],'r--','LineWidth',1.2)
hold off
xlabel('GP Prediction (Hz)')
ylabel('Reference (Hz)')
axis([100 180 100 180])
title('ITA Mode - Frequency')
h = gca;
h.FontSize = 11;
hold off

subplot(2,2,2)
hold on
GP_predict_ITA_gref = predict_test(1:50,end-2);
plot(GP_predict_ITA_gref,testing.Y(1:50,2),'ko','LineWidth',1.2,'MarkerSize',8)
plot([-100 50], [-100 50], 'r--','LineWidth',1.2)
hold off
xlabel('GP Prediction (rad/s)')
ylabel('Reference (rad/s)')
axis([-100 50 -100 50])
title('ITA Mode - Growth rate')
h = gca;
h.FontSize = 11;

subplot(2,2,3)
hold on
GP_predict_CAV_fref = predict_test(1:50,end-1);
plot(GP_predict_CAV_fref,testing.Y(1:50,3),'ko','LineWidth',1.2,'MarkerSize',8)
plot([200 350], [200 350], 'r--','LineWidth',1.2)
hold off
xlabel('GP Prediction (Hz)')
ylabel('Reference (Hz)')
axis([200 350 200 350])
title('Cavity Mode - Frequency')
h = gca;
h.FontSize = 11;

subplot(2,2,4)
hold on
GP_predict_CAV_gref = predict_test(1:50,end);
plot(GP_predict_CAV_gref,testing.Y(1:50,4),'ko','LineWidth',1.2,'MarkerSize',8)
plot([-200 150], [-200 150], 'r--','LineWidth',1.2)
hold on
xlabel('GP Prediction (rad/s)')
ylabel('Reference (rad/s)')
axis([-200 150 -200 150])
title('Cavity Mode - Growth Rate')
h = gca;
h.FontSize = 11;
