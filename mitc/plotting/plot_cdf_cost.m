function plot_cdf_cost(CollectData, J, T_pl, penalty, incentive, savefolder, savename)
% PLOT_CDF_COST - 
%
% Syntax:
% plot_cdf_cost(CollectData, J, savefolder, savename)
%
% Inputs:
%   CollectData :
%   J :
%   T_pl:
%   penalty:
%   incentive:
%   savefolder :
%   savename :

%--- (m) Cost distribution
c_opt=CollectData(:,J+2)+...
    CollectData(:,J+7) * penalty - ...
    CollectData(:,J+8) * incentive;
c_all=CollectData(:,J+4)+...
    (max(0,(CollectData(:, J+3) - T_pl ))) * penalty - ...
    (max(0,(T_pl - CollectData(:,J+3)))) * incentive;

h = figure;
hold on
cost_cdfdist(c_opt,c_all);
hold off

%--- Export figures
file = [savefolder savename];
export_fig(h, file)
end