clear
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Perform Monte Carlo simulation for task 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENTATION
%   ===> Generate random samples for uncertain parameters
%   ===> Calculate the corresponding response for each sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: UQLab (www.uqlab.com)
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1-Basic inputs info & initilization
options = optimoptions('fsolve','Display','off');
% Remove tau_c from the flame parameter vector
flame_mean = [2.85,0.7,1.8,3.3]/1000; N = 70; delta_t = 2e-4;

% Lower_bound first row, upper_bound second row, all uniform distributions
uncertainty = 0.1;
parameter_bound = [flame_mean-flame_mean*uncertainty;flame_mean+flame_mean*uncertainty];

% 2-Generate samples
uqlab
for ii = 1:4
    Input.Marginals(ii).Type = 'Uniform';
    Input.Marginals(ii).Parameters = [0 1];
end
ParaInput = uq_createInput(Input);  % UQLab function
sample_number = 20000;

% Without tau & R
X = uq_getSample(sample_number,'Halton');  % UQLab function
scaled_samples = Scale(X, parameter_bound);

% Add tau & R & extend X
s_tau = normrnd(4.06,0.15,[sample_number,1]);   s_R = 0.2*rand(sample_number,1)-0.9;
X = [X(:,1:2),1/2.8*(s_tau-2),X(:,3:4),1/0.4*(s_R+1)];
scaled_samples = [scaled_samples(:,1:2),s_tau/1000,scaled_samples(:,3:4),s_R];

% Calculate the responses
count = sample_number;

FR = zeros(3,1);  GR = zeros(3,1); 
Y = zeros(sample_number,4);
for cal_resp = 1:sample_number
    
    current_h = FIR_coeff_filling(scaled_samples(cal_resp,1:5),N,delta_t);
    EigenFun = @(omega) Eigenmode_solver(omega,current_h,scaled_samples(cal_resp,end),N,delta_t);
    % Configure the initial conditions
    initial_value = [45.94*2*pi,-50.15;130*2*pi,-70.94;250*2*pi,-6];
    
    for k = 1:3
        Eigen = fsolve(EigenFun, initial_value(k,1)-initial_value(k,2)*1i,options);    % solving characteristic equation
        FR(k) = real(Eigen)/(2*pi);    % Unit: Hz
        GR(k) = -imag(Eigen);          % Unit: rad/s
    end
    
    % Construct the response matrix
    Y(cal_resp,:) = [FR(2),GR(2),FR(3),GR(3)];
    count = count - 1

end

save 'MC.mat' X Y

% Post-processing
figure(1)
title('ITA mode')
plot(Y(:,1),Y(:,2),'ko','MarkerFaceColor','k')
xlabel('Frequency')
ylabel('Growth Rate')

figure(2)
title('Cavity mode')
plot(Y(:,3),Y(:,4),'ko','MarkerFaceColor','k')
xlabel('Frequency')
ylabel('Growth Rate')