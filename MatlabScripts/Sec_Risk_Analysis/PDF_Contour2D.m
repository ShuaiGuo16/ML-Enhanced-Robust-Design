function [new_count,new_X,new_Y] = PDF_Contour2D(MC,range,interval)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OBJECTIVE
%   ===> Draw 2D PDF contours from Monte Carlo data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS
%   ===> MC:  N x 2 matrix, contains all the 2D data points
%   ===> range:  2 x 2 matrix, min/max ranges (column) for each
%            parameter (row)
%   ===> interval: 1 x 2 vector, resolution for each parameter
%   NOTICE:   range/interval has to be an integer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS
%   ===> new_count: number of samples fall in the interval area
%   ===> new_X/Y: grid for post-processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by S. Guo (TUM), Oct. 2018
% Email: guo@tfd.mw.tum.de
% Version: MATLAB R2018b
% Package: None
% Ref: [1] S. Guo, C. F. Silva, W. Polifke, "Efficient robust design for
% thermoacoustic instability analysis: A Gaussian process approach",
% 2019, ASME Turo Expo, Phoenix, USA, GT2019-90732
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read data
MC_FR = MC(:,1);  MC_GR = MC(:,2);
Ran_FR = range(1,:);  Ran_GR = range(2,:);

% Data storage point
int_FR = interval(1);
int_GR = interval(2);
ele_FR = (max(Ran_FR)-min(Ran_FR))/interval(1);
ele_GR = (max(Ran_GR)-min(Ran_GR))/interval(2);
FR = linspace(min(Ran_FR)+int_FR/2,max(Ran_FR)-int_FR/2,ele_FR);
GR = linspace(min(Ran_GR)+int_GR/2,max(Ran_GR)-int_GR/2,ele_GR);
[X,Y] = meshgrid(GR, FR);

% Data sorting
count = zeros(ele_FR,ele_GR);

for i = 1:ele_FR
    for j = 1:ele_GR
        center_point_FR = FR(i);
        center_point_GR = GR(j);
        area_range = [center_point_FR-int_FR/2,center_point_FR+int_FR/2,center_point_GR-int_GR/2,center_point_GR+int_GR/2];
        count(i,j) = points_count(area_range,MC_FR,MC_GR)/20000/(int_GR*int_FR);      % PDF  
    end   
end

% Interpolate the data
newpoints = 100;
new_FR = linspace(min(Ran_FR)+int_FR/2,max(Ran_FR)-int_FR/2,newpoints);
new_GR = linspace(min(Ran_GR)+int_GR/2,max(Ran_GR)-int_GR/2,newpoints);
[new_X,new_Y] = meshgrid(new_GR, new_FR);   % Reverse the order
new_count = interp2(X,Y,count,new_X,new_Y,'cubic');

end

