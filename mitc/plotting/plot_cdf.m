function plot_cdf(CollectData, J, T_orig, T_pl, nsimulations, savefolder, savename)
%PLOT_CDF plots the cumulative distribution function
%
% Inputs:
%   CollectData : double
%       Results from simulation
%   J : double
%       number of mitigation measures
%   T_orig : double
%       project duration as in the original plan 
%   T_pl : double
%       planned/target duration of the project 
%   nsimulations : double
%       number of run simulations


h = figure;
hold on
y_opt=CollectData(:,J+1);
y_all=CollectData(:,J+3);
y_0=CollectData(:,J+5);
y_0_nouncertainty=T_orig*ones(nsimulations,1);

fitting(y_opt,y_all,y_0,y_0_nouncertainty,T_pl);
hold off

%--- Export figures
file = [savefolder savename];
saveas(h, file, 'png');
saveas(h, file, 'fig');
saveas(h, file, 'eps');

end
