function plot_freq_activity(CP_0, CP_opt, K, P_ki, N)
% plot_freq_activity
%
%
%
%

%--- (k)Critical path-activities criticality analysis
%before optimization
CP_0_ki=(tabulate(CP_0));
CP_0_ki=CP_0_ki(:,2);
CP_0_ki=[CP_0_ki ;zeros(K-numel(CP_0_ki),1)];
CP_0_ki=(CP_0_ki.*P_ki);

freq_0_i=sum(CP_0_ki); %frequency of every activity being on a critical path before optimization
freq_0_i=([freq_0_i;freq_0_i/length(CP_0)*100])';%percentage of every activity being on a critical path before optimization

%after optimization
CP_opt_ki=(tabulate(CP_opt));
CP_opt_ki=CP_opt_ki(:,2);
CP_opt_ki=[CP_opt_ki ;zeros(K-numel(CP_opt_ki),1)];
CP_opt_ki=(CP_opt_ki.*P_ki);

freq_opt_i=sum(CP_opt_ki); %frequency of every activity being on a critical path after optimization
freq_opt_i=([freq_opt_i;freq_opt_i/length(CP_opt)*100])';%percentage of every activity being on a critical path after optimization

%     Bar chart for freq_0_i and freq_opt_i
    figure
    b=bar([freq_0_i(1:N-1,2),freq_opt_i(1:N-1,2)],'grouped','FaceColor','flat');
    b(1).CData = [0 0 0];
    b(2).CData = [0.7 0.7 0.7];
    xlabel('Activity ID','FontSize',20);
    ylabel('Percentage','FontSize',20);
    legend('No Mit','Tentative');
    bx = gca;
    bx.FontSize = 16; 
    bx.YGrid = 'on';
    xticks(1 : N-1)
    set(bx,'TickLength',[0, 0])
    hold off