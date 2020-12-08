function plot_pdf_cost(CollectData, J, savefolder, savename)

%--- (m) Cost distribution
c_opt=CollectData(:,J+2);
c_all=CollectData(:,J+4);

h = figure;
hold on
cost_pdfdist(c_opt,c_all);
hold off

%--- Export figures
file = [savefolder savename];
saveas(h, file, 'png');
saveas(h, file, 'fig');
saveas(h, file, 'eps');
end