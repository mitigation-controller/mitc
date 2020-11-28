function plot_cdf_cost(CollectData, J)

%--- (m) Cost distribution
c_opt=CollectData(:,J+2);
c_all=CollectData(:,J+4);

figure
cost_cdfdist(c_opt,c_all);