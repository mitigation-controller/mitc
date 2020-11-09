% Temporary file to test modular approach to mit_plan

addpath('bin', 'plotting')


%--- User input
nsimulations=1000;
T_pl=1466;

%--- 1) Import project data
filename = '..\data\Case study.xlsx';
[dataDouble, dataCell] = import_project(filename);

%--- 2) Parse data
parsedData = parse_data(dataDouble, dataCell);

%--- 3) Prepare data for simulation

% 3a) Generate matrix with all paths
[parsedData.P_ki, A] = fill_path_matrix(parsedData.R_ii, parsedData.nActivities);

% 3b) Select critical paths to reduce the simulation time
[parsedData.T_orig, parsedData.P_cr_0, parsedData.K] = ...
                         select_critical_paths(...                         
                            parsedData.P_ki,...
                            parsedData.durationActivities,...
                            parsedData.riskEventsDuration,...
                            parsedData.E_ie);

%--- 4) Run simulation
collectData = mitc_simulation(parsedData, nsimulations, T_pl);

%--- 5) Treat simulation results


%--- 6) Generate plots
plot_network(A, dataCell);
plot_freq_mitigation(collectData, nsimulations);
% 

%--- 7) Save data and plots