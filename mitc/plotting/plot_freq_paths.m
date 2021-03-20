function h = plot_freq_paths(CP_0, CP_opt, K, savefolder, savename)


%--- frequency of critical paths with no mitigation measures
freq_k0=tabulate(CP_0);freq_k0=freq_k0(:,3);
freq_k0=[freq_k0 ;zeros(K-numel(freq_k0),1)];

%--- (h) frequency of critical paths with optimal mitigation measures
freq_k_opt=tabulate(CP_opt);freq_k_opt=freq_k_opt(:,3);
freq_k_opt=[freq_k_opt ;zeros(K-numel(freq_k_opt),1)];
  
%     %Bar chart for freq_k0 and freq_k_opt
h = figure;
hold on
b=bar([freq_k0,freq_k_opt],'FaceColor','flat');
b(1).CData = [0 0 0];
b(2).CData = [0.7 0.7 0.7];
xlabel('Project path ID','FontSize',20);
ylabel('Percentage','FontSize',20);
legend('No Mit','MitC');
bx = gca;
bx.FontSize = 16;
bx.YGrid = 'on';
xticks(1 : K)
set(bx,'TickLength',[0, 0])
hold off

%--- Export figures
if ~isempty(savename) && ~isempty(savefolder)
    file = [savefolder savename];
    export_fig(h, file)
end
end
