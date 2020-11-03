% Temporary file to test modular approach to mit_plan

addpath('bin', 'plotting')

%--- 1) Import project data
filename = '..\data\Case study.xlsx';
[dataDouble, dataCell] = import_project(filename);

%--- 2) Parse data
parsedData = parse_data(dataDouble, dataCell);

%--- 3) Prepare data for simulation

% 3a) Generate matrix with all paths
[P_ki, A] = fill_path_matrix(parsedData.R_ii, parsedData.nActivities);

% 3b) Select critical paths to reduce the simulation time
[T_orig, P_cr_0, K] = select_critical_paths(...                         
                         P_ki,...
                         parsedData.durationActivities,...
                         parsedData.riskEventsDuration,...
                         parsedData.E_ie);

%--- 4) Pre-draw random numbers

%--- 5) Run simulation
% mitc_simulation

%--- 6) Treat simulation results


%--- 7) Generate plots
% plot_network(A, dataCell);
% 

%--- 8) Save data and plots