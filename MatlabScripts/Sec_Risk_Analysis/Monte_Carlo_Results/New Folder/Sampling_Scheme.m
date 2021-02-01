clear
clc


clearvars
uqlab

InputOpts.Marginals(1).Type = 'Uniform';
InputOpts.Marginals(1).Parameters = [0 1];
InputOpts.Marginals(2).Type = 'Uniform';
InputOpts.Marginals(2).Parameters = [0 1];

myInput = uq_createInput(InputOpts);


figure()
subplot(2,2,1)
X_MC = uq_getSample(50,'MC');
uq_plot(X_MC(:,1), X_MC(:,2), '.', 'MarkerSize', 14)
xlabel('$\mathrm{X_1}$')
ylabel('$\mathrm{X_2}$')
title('Random Sampling')

subplot(2,2,2)
X_LHS = uq_getSample(50, 'LHS');
uq_plot(X_LHS(:,1), X_LHS(:,2), '.', 'MarkerSize', 14)
xlabel('$\mathrm{X_1}$')
ylabel('$\mathrm{X_2}$')
title('LHS Sampling')


subplot(2,2,3)
X_Sobol = uq_getSample(50,'Sobol');
uq_plot(X_Sobol(:,1), X_Sobol(:,2), '.', 'MarkerSize', 14)
xlabel('$\mathrm{X_1}$')
ylabel('$\mathrm{X_2}$')
title('Sobol Sampling')


subplot(2,2,4)
X_Halton = uq_getSample(50,'Halton');
uq_plot(X_Halton(:,1), X_Halton(:,2), '.', 'MarkerSize', 14)
xlabel('$\mathrm{X_1}$')
ylabel('$\mathrm{X_2}$')
title('Halton Sampling')