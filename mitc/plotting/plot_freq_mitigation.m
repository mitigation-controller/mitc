function plot_freq_mitigation(collectData, simPa, nsimulations, savefolder, savename)

% TEMPORARY VARIABLE RENAMING
N = simPa.nActivities;
J = simPa.nMitigations;

%--- frequency of mitigation measures
freq_j=(sum(collectData(:,1:J)))';freq_j=freq_j./nsimulations*100;

%Bar chart for freq_j
h = figure;
hold on
b=bar(freq_j,'FaceColor','flat');
b.CData = [0.7 0.7 0.7];
xlabel('Mitigation measure ID','FontSize',20);
ylabel('Percentage','FontSize',20);
bx = gca;
bx.FontSize = 16; 
bx.YGrid = 'on';
xticks(1 : N-1)
set(bx,'TickLength',[0, 0])
hold off

%--- Export figures
file = [savefolder savename];
export_fig(h, file)
end