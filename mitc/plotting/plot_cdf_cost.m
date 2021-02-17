function plot_cdf_cost(CollectData, J, savefolder, savename)
% PLOT_CDF_COST - 
%
% Syntax:
% plot_cdf_cost(CollectData, J, savefolder, savename)
%
% Inputs:
%   CollectData :
%   J :
%   savefolder :
%   savename :

%--- (m) Cost distribution
c_opt=CollectData(:,J+2);
c_all=CollectData(:,J+4);

h = figure;
hold on
cost_cdfdist(c_opt,c_all);
hold off

%--- Export figures
file = [savefolder savename];
export_fig(h, file)
end