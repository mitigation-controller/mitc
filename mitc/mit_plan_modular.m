% Temporary file to test modular approach to mit_plan
clear
close all
rng('default') %For reproducibility

addpath('bin', 'plotting', 'modules')


%--- User input
Config.nSimulations = 1000;
Config.T_pl = 1466;
Config.penalty = 8500; %Penalty per day of delay
Config.incentive = 5000; %Incentive per day of finishing early

[filename, pathname] = uigetfile('..\data\*.xlsx', 'Select project data file');
Config.filename = [pathname filename];
ID = datestr(now, 'yyyy-mm-dd__HH-MM-SS');
Config.savefolder = strcat('..\results\', ID, '\');

% Create export directory
if ~exist(Config.savefolder,'dir')
    mkdir(Config.savefolder);
end

%--- 1) Import project data
[dataDouble, dataCell] = import_project(Config.filename);

%--- 2) Parse data
Data = parse_data(dataDouble, dataCell);

%--- 3) Prepare data for simulation
% 3a) Generate matrix with all paths
[Data.nodesInPath, Data.linkedActivities, Data.nPaths] = generate_paths(Data.R_ii, Data.nActivities);

% 3b) Find the critical path
[Data.T_orig, Data.P_cr_0] = find_critical_path(...                         
                                    Data.nodesInPath,...
                                    Data.durationActivitiesTotal);                        
                        
%--- 4) Run simulation
[Results, CP_0, CP_opt, Corr_ii, cancelSimulation] = mitc_simulation(Data, Config);

%--- 5) Generate and export plots
if cancelSimulation == 0
    plot_network(Data.linkedActivities, dataCell,...
                 Config.savefolder, 'fig_1');

    plot_freq_mitigation(Results, Data, Config.nSimulations,...
                         Config.savefolder, 'fig_2');

    plot_freq_paths(CP_0, CP_opt, Data.nPaths,...
                    Config.savefolder, 'fig_3');

    plot_freq_activity(CP_0, CP_opt, Data.nPaths, Data.nodesInPath, Data.nActivities,...
                       Config.savefolder, 'fig_4');

    plot_cdf(Results, Data.nMitigations,Data.T_orig,...
                Config.T_pl, Config.nSimulations,...
                 Config.savefolder, 'fig_5');

    plot_cdf_cost(Results, Data.nMitigations,...
                Config.T_pl, Config.penalty, Config.incentive,...
                  Config.savefolder, 'fig_6');

    plot_pdf_cost(Results, Data.nMitigations,...
                Config.T_pl, Config.penalty, Config.incentive,...
                  Config.savefolder, 'fig_7');
end

%--- 6) Save Config, Data, and Results structures in a single data file
if cancelSimulation == 0
    export_results(Config, Data, Results);
end