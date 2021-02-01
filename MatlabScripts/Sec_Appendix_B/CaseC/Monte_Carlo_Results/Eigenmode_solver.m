function [ CharEqn ] = Eigenmode_solver(omega, h, r_out, N, delta_t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Construct eigenvalue equations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> omega: complex frequency
%   ===> h: row vector, impulse response coefficients
%            upper bound (second row) for uncertain parameters
%   ===> r_out: reflection coefficient at the combustor outlet
%   ===> N: number of impulse response coefficient
%   ===> delta_t: scalar, sampling interval of impulse response (unit: s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> CharEqn: eigenvalue equation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: none
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Basic parameters
l_Plen = 0.17;   c_up = 343.1143;  area_ratio_1 = 29.76;
l_Swir = 0.18;   area_ratio_2 = 0.13;  
c_down = 880.61;  temp_jump = 5.59;   imp_ratio = 2.57;
l_com = 0.75;

%% To express flame model (FIR)
F = 0;
for k = 1:N
    F = F + h(k)*exp(-omega*1i*k*delta_t);
end

%% Construct upstream acoustic matrix

% Plenum & 1st area jump
T_upstream(1,:) = 0.5*[(1+area_ratio_1)*exp(-omega*1i*l_Plen/c_up),(1-area_ratio_1)*exp(omega*1i*l_Plen/c_up)];
T_upstream(2,:) = 0.5*[(1-area_ratio_1)*exp(-omega*1i*l_Plen/c_up),(1+area_ratio_1)*exp(omega*1i*l_Plen/c_up)];

% Swirler tube
T_swirler = [exp(-omega*1i*l_Swir/c_up),0;0,exp(omega*1i*l_Swir/c_up)];

% Flame & 2st area jump
T_flame(1,:) = [0.5*(imp_ratio+area_ratio_2+area_ratio_2*temp_jump*F),0.5*(imp_ratio-area_ratio_2-area_ratio_2*temp_jump*F)];
T_flame(2,:) = [0.5*(imp_ratio-area_ratio_2-area_ratio_2*temp_jump*F),0.5*(imp_ratio+area_ratio_2+area_ratio_2*temp_jump*F)];

% Combustor
T_comb = [exp(-omega*1i*l_com/c_down),0;0,exp(omega*1i*l_com/c_down)];

% Full system without B.C.
T = T_comb*T_flame*T_swirler*T_upstream;

%% Construct characteristic equation
CharEqn = T(2,2)-r_out*T(1,2)+T(2,1)-r_out*T(1,1);

end

