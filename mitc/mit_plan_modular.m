% Temporary file to test modular approach to mit_plan
clear
close all
rng('default') % To ensure reproducibility

addpath('bin', 'plotting', 'modules')


%--- User input
Config.nSimulations = 3000;
Config.T_target = 1466;
Config.parameterMode = 'Advanced';

switch Config.parameterMode
    case 'Basic'
        Config.penalty = 9999999; % Penalty per day of delay
        Config.incentive = 0; % Incentive per day of finishing early
    case 'Advanced'
        Config.penalty = 3000; %Penalty per day of delay
        Config.incentive = 3000; %Incentive per day of finishing early
end

% --- Get data file
% [filename, pathname] = uigetfile('..\data\*.xlsx', 'Select project data file');
% Config.filename = [pathname filename];
[filepath,~,~] = fileparts(mfilename('fullpath'));
mainDir = fileparts(filepath);
Config.filename = fullfile(mainDir, 'data','Case study 1.xlsx');

ID = datestr(now, 'yyyy-mm-dd__HH-MM-SS');
Config.savefolder = strcat('..\results\', ID, '\');

%--- Create export directory
if ~exist(Config.savefolder,'dir')
    mkdir(Config.savefolder);
end

%--- 1) Import project data
[dataDouble, dataCell] = import_project(Config.filename);

% Verify raw data
[status, message] = verify_raw_data(dataDouble, dataCell);

%--- 2) Parse data
[Data, dataDouble, dataCell] = parse_data(dataDouble, dataCell);

%--- 3) Generate matrix with all paths
Data = generate_paths(Data);

%--- 4) Find the critical path
Data = find_critical_path(Data);                                            
                        
%--- 5) Run simulation
[Results, CP_0, CP_opt, Corr_ii, cancelSimulation] = mitc_simulation(Data, Config);

%--- 6) Generate and export plots
if cancelSimulation == 0
    fig_1 = plot_network(Data.linkedActivities, dataCell,...
                 Config.savefolder, 'fig_1');

    fig_2 = plot_freq_mitigation(Results, Data, Config.nSimulations,...
                         Config.savefolder, 'fig_2');

    fig_3 = plot_freq_paths(CP_0, CP_opt, Data.nPaths,...
                    Config.savefolder, 'fig_3');

    fig_4 =  plot_freq_activity(CP_0, CP_opt, Data.nPaths, Data.nodesInPath, Data.nActivities,...
                       Config.savefolder, 'fig_4');

    fig_5 = plot_cdf(Results, Data.nMitigations,Data.T_orig,...
                Config.T_target, Config.nSimulations,...
                 Config.savefolder, 'fig_5');
              
    fig_6 = plot_cost_distribution('cdf', Results, Data, Config, 'fig_6');
    fig_7 = plot_cost_distribution('pdf', Results, Data, Config, 'fig_7');
end

%--- 7) Save Config, Data, and Results structures in a single data file
if cancelSimulation == 0
    export_results(Config, Data, Results);
end