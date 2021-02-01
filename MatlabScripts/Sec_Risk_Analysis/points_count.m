function [count_num] = points_count(area_range,f_MC_FR,f_MC_GR)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Count point falling in a specific area (area_range)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> area_range: row vector, 4 limit coordinates for the specific 
%            area 
%   ===> f_MC_FR: column vector, frequency data
%   ===> f_MC_GR: column vector, growth rate data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> count_num: number of samples fall in the specific area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = size(f_MC_GR,1);
count_num = 0;
for i = 1:n
    if f_MC_FR(i)>=area_range(1) && f_MC_FR(i)<=area_range(2) && f_MC_GR(i)>=area_range(3) && f_MC_GR(i)<=area_range(4)
        count_num = count_num+1;
    else
        continue
    end
end

end

