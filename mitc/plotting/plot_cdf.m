function plot_cdf(CollectData, nMit, T_orig, T_planned, nSim, savefolder, savename)
%PLOT_CDF Plots the cumulative distribution function
%
% Inputs:
%   CollectData : double
%       Results from simulation
%   nMit : double
%       number of mitigation measures
%   T_orig : double
%       project duration as in the original plan 
%   T_planned : double
%       planned/target duration of the project 
%   nSim : double
%       number of run simulations
%

h = figure;
hold on
y_opt = CollectData(:, nMit+1);
y_all = CollectData(: ,nMit+3);
y_0 = CollectData(:, nMit+5);
y_0_nouncertainty = T_orig * ones(nSim,1);

fitting(y_opt,y_all,y_0,y_0_nouncertainty,T_planned);
hold off

%--- Export figures
file = [savefolder savename];
export_fig(h, file)
end
