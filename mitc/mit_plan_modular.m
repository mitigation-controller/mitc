% Temporary file to test modular approach to mit_plan

addpath('bin', 'plotting', 'modules')


%--- User input
Config.nsimulations=500;
Config.T_pl=1466;

%--- 1) Import project data
filename = '..\data\Case study.xlsx';
[dataDouble, dataCell] = import_project(filename);

%--- 2) Parse data
Data = parse_data(dataDouble, dataCell);

%--- 3) Prepare data for simulation

% 3a) Generate matrix with all paths
[Data.P_ki, A] = fill_path_matrix(Data.R_ii, Data.nActivities);

% 3b) Select critical paths to reduce the simulation time
[Data.T_orig, Data.P_cr_0, Data.K] = ...
                         select_critical_paths(...                         
                            Data.P_ki,...
                            Data.durationActivities,...
                            Data.riskEventsDuration,...
                            Data.E_ie);

%--- 4) Run simulation
[Results, CP_0, CP_opt] = mitc_simulation(Data, Config.nsimulations, Config.T_pl);

%--- 5) Treat simulation results


%--- 6) Generate plots
plot_network(A, dataCell);
plot_freq_mitigation(Results, Data, Config.nsimulations);
plot_freq_paths(CP_0, CP_opt, Data.K);
plot_freq_activity(CP_0, CP_opt, Data.K, Data.P_ki, Data.nActivities);
plot_cdf(Results, Data.nMitigations, Data.T_orig, Config.T_pl, Config.nsimulations);

%--- 7) Save data and plots