function [ scaled_training ] = Scale(training_matrix, parameter_bound)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> scale the input training data to realistic physical ranges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> training_matrix: matrix, each row is a normalized training sample
%   ===> parameter_bound: 2 x 5 matrix, lower bound (first row) and 
%            upper bound (second row) for uncertain parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> scaled_training: matrix, each row is a scaled training sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

para_num = size(parameter_bound,2);
scaled_training = zeros(size(training_matrix));

for i = 1:para_num
        scaled_training(:,i) = (parameter_bound(2,i)-parameter_bound(1,i))*...
        training_matrix(:,i)+parameter_bound(1,i);
end

end

