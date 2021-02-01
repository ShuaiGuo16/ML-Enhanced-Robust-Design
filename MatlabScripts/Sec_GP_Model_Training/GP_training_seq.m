clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Train 4 Gaussian Process (GP) models using Halton
%            sequential sampling scheme
%   ===> 4 GP models correspond to: ITA mode frequency/growth
%            rate, CAV (cavity) mode frequency/growth rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%   ===> Start with initial sample size, then add training samples
%            sequentially using Halton scheme
%   ===> GP model training is performed via UQLab toolbox
%   ===> Output GP models and their leave-one-out errors as well
%            as the testing error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1-Basic inputs info & initilization
options = optimoptions('fsolve','Display','off');
flame_mean = [2.85,0.7,3,1.8,3.3]/1000; N = 70; delta_t = 2e-4;

% Lower_bound first row, upper_bound second row, all uniform distributions
uncertainty = 0.1;
parameter_bound = [flame_mean-flame_mean*uncertainty;flame_mean+flame_mean*uncertainty];
parameter_bound(1,3) = 2/1000;   parameter_bound(2,3) = 4.8/1000;    % Correct tau_c bound
parameter_bound = [parameter_bound,[-1;-0.6]];    % Insert R as the last column

predict_test = [];

% Testing locations
load 'testing.mat'

%% 2-Sequential training
% UQLab input specificaiton
uqlab
for ii = 1:6
    Input.Marginals(ii).Type = 'Uniform';
    Input.Marginals(ii).Parameters = [0 1];
end
ParaInput = uq_createInput(Input);  % (UQLab function)

% Start iteration
for iteration = 1:15
    
    if iteration == 1
        % Specify the number of initial training samples 
        sample_number = 18;
        training.X = uq_getSample(sample_number,'Halton');   % (UQLab function)
        training.Y = Calculate_resp(training.X, parameter_bound, N, delta_t, options);
        
        % Train initial GP model
        [ Metaopts ] = CreateMetaOpts_Halton(training.X, training.Y);
        GP = uq_createModel(Metaopts);   % (UQLab function)
        % Obtain error info (leave-one-out error)
        errITA.fref = GP.Error(1).LOO*GP.Internal.Error(1).varY;
        errITA.gref = GP.Error(2).LOO*GP.Internal.Error(2).varY;
        errCav.fref = GP.Error(3).LOO*GP.Internal.Error(3).varY;
        errCav.gref = GP.Error(4).LOO*GP.Internal.Error(4).varY;
        
    else
        % Generate new sample 
        incre = 6;   % Add 6 samples at one time
        new_X = uq_enrichHalton(training.X,incre);  % Enrich the training sample set (UQLab function)
        new_response = Calculate_resp(new_X,parameter_bound,N,delta_t,options);
        
        % Update training matrix
        training.X = [training.X;new_X];
        training.Y = [training.Y;new_response];
        
         % GP training
         [ Metaopts ] = CreateMetaOpts_Halton(training.X, training.Y);
        GP = uq_createModel(Metaopts);   % (UQLab function)
        errITA.fref = [errITA.fref;GP.Error(1).LOO*GP.Internal.Error(1).varY];   % Absolute values
        errITA.gref = [errITA.gref;GP.Error(2).LOO*GP.Internal.Error(2).varY];
        errCav.fref = [errCav.fref;GP.Error(3).LOO*GP.Internal.Error(3).varY];
        errCav.gref = [errCav.gref;GP.Error(4).LOO*GP.Internal.Error(4).varY];
        
    end
     
     % Predicting Testing Set
     predict_test = [predict_test, uq_evalModel(GP, testing.X)];  % (UQLab function)
     
end

save 'GP.mat' GP
save 'training.mat' training
save 'errITA.mat' errITA
save 'errCav.mat' errCav
save 'predict_test.mat' predict_test
