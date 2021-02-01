function [ response ] = Calculate_resp(X, parameter_bound, N, delta_t, options)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Calculate the responses of the training samples using 
%            acoustic network solver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> X: matrix, each row represents one training sample
%   ===> parameter_bound: 2 x 5 matrix, lower bound (first row) and 
%            upper bound (second row) for uncertain parameters
%   ===> N: scalar, number of impulse response coefficients
%   ===> delta_t: scalar, sampling interval of impulse response (unit: s)
%   ===> options: Display options for fsolve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> response: matrix, each row contains four responses
%            (ITA frequency/growth rate, CAV frequency/growth rate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: none
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Scale samples to their realistic physical magnitudes
scaled_samples = Scale(X, parameter_bound);
sample_number = size(scaled_samples,1);

FR = zeros(3,1);  GR = zeros(3,1); 
response = zeros(sample_number,4);
for cal_resp = 1:sample_number
    
    current_h = FIR_coeff_filling(scaled_samples(cal_resp,1:5),N,delta_t);
    % Construct eigenvalue equation
    EigenFun = @(omega) Eigenmode_solver(omega,current_h,scaled_samples(cal_resp,end),N,delta_t);
    % Configure the initial conditions
    initial_value = [45.94*2*pi,-50.15;130*2*pi,-70.94;250*2*pi,-6];
    
    for k = 1:3
        Eigen = fsolve(EigenFun, initial_value(k,1)-initial_value(k,2)*1i,options);    % solving characteristic equation
        FR(k) = real(Eigen)/(2*pi);    % Unit: Hz
        GR(k) = -imag(Eigen);          % Unit: rad/s
    end
    
    % Construct the response matrix
    response(cal_resp,:) = [FR(2),GR(2),FR(3),GR(3)];

end

end

