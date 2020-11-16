function plot_cdf(CollectData, J, T_orig, T_pl, nsimulations)

figure

y_opt=CollectData(:,J+1);
cdfplot(y_opt)
hold on
y_all=CollectData(:,J+3);
cdfplot(y_all)
hold on
y_0=CollectData(:,J+5);
cdfplot(y_0)
hold on
y_0_nouncertainty=T_orig*ones(nsimulations,1);
hold off

fitting(y_opt,y_all,y_0,y_0_nouncertainty,T_pl);