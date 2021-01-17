% Temporary file to test modular approach to mit_plan
clear all

tic
addpath('bin', 'plotting', 'modules')


%--- User input
Config.nsimulations = 500;
Config.T_pl = 1466;

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
[Data.P_ki, Data.linkedActivities] = fill_path_matrix(Data.R_ii, Data.nActivities);

% 3b) Select critical paths to reduce the simulation time
[Data.T_orig, Data.P_cr_0, Data.K, Data.P_ki] = ...
                         select_critical_paths(...                         
                            Data.P_ki,...
                            Data.durationActivities,...
                            Data.riskEventsDuration,...
                            Data.E_ie,...
                            Config.T_pl);

%--- 4) Run simulation
[Results, CP_0, CP_opt] = mitc_simulation(Data, Config.nsimulations, Config.T_pl);

%--- 5) Generate and export plots
plot_network(Data.linkedActivities, dataCell,...
             Config.savefolder, 'fig_1');
         
plot_freq_mitigation(Results, Data, Config.nsimulations,...
                     Config.savefolder, 'fig_2');
                 
plot_freq_paths(CP_0, CP_opt, Data.K,...
                Config.savefolder, 'fig_3');
            
plot_freq_activity(CP_0, CP_opt, Data.K, Data.P_ki, Data.nActivities,...
                   Config.savefolder, 'fig_4');
               
plot_cdf(Results, Data.nMitigations, Data.T_orig, Config.T_pl, Config.nsimulations,...
         Config.savefolder, 'fig_5');
     
plot_cdf_cost(Results, Data.nMitigations,...
              Config.savefolder, 'fig_6');
          
plot_pdf_cost(Results, Data.nMitigations,...
              Config.savefolder, 'fig_7');

%--- 6) Save Config, Data, and Results structures in a single data file
export_results(Config, Data, Results);

toc
