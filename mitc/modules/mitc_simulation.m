function [Results, CP_0, CP_opt, Corr_ii, cancelSimulation] = mitc_simulation(Data, Config)
% MITC_SIMULATION
%
% Inputs:
%   Data : structure
%       Structure that contains all simulation data
%   Config : structure
%       Structure that contains user input
%
% Outputs:
%   Results : double
%       For info, check: https://github.com/mitigation-controller/mitc/wiki/Variable-Names
%   CP_0
%   CP_opt
%   Corr_ii
%   cancelSimulation : boolean
%       Signal whether the simulation was aborted        
%
% License: Apache 2.0
%

%% Check whether required structure fields exist
expFieldsData = {'durationActivitiesTotal',...
                'nActivities',...
                'sharedUncertainties',...
                'nSharedUncertainties',...
                'relActivitiesUncertainties',...
                'durationActivitiesCorrelation',...
                'durationActivitiesNoCorrelation',...
                'riskEventsDuration',...
                'riskProbability',...
                'nRisks',...
                'mitigatedDuration',...
                'nMitigations',...
                'mitigationCost',...
                'relActivitiesMitigations',...
                'relActivitiesRisks',...
                'nPaths',...
                'nodesInPath'};
           
expFieldsConfig = {'nSimulations',...
                 'T_target',...
                 'penalty',...
                 'incentive'}; 

verify_fieldnames(Data, expFieldsData);
verify_fieldnames(Config, expFieldsConfig);

nSimulations = Config.nSimulations;

%% --- Draw random numbers 
d_i_total_matrix = draw_random_numbers(Data.durationActivitiesTotal,...
                                       Data.nActivities,...
                                       nSimulations);  
                                   
d_i_correlation_matrix = draw_random_numbers(Data.durationActivitiesCorrelation,...
                                             Data.nActivities,...
                                             nSimulations); 
                                         
% Shared activity durations
d_s_matrix = draw_random_numbers(Data.sharedUncertainties,...
                                 Data.nSharedUncertainties,...
                                 nSimulations); 
                             
% Mitigated time                             
m_j_matrix = draw_random_numbers(Data.mitigatedDuration,...
                                 Data.nMitigations,...
                                 nSimulations);
                             
% Duration risk event                             
d_r_matrix = draw_random_numbers(Data.riskEventsDuration,...
                                 Data.nRisks,...
                                 nSimulations);    
                             
% Mitigation cost according to the mitigation duration                            
c_j_matrix = mitigation_cost(Data.nMitigations,...
                             nSimulations,...
                             Data.mitigatedDuration,...
                             Data.mitigationCost,...
                             m_j_matrix); 
                         
d_i_noCorrelation_parameters = calculate_no_correlation(d_i_total_matrix,...
                                d_i_correlation_matrix,...
                                Data.durationActivitiesNoCorrelation);
                                Data.durationActivitiesCorrelation);

d_i_noCorrelation_matrix = draw_random_numbers(d_i_noCorrelation_parameters,...
                                               Data.nActivities,...
                                               nSimulations);    

%% --- Monte Carlo simulation
% Start a counter for the critical paths for every Monte Carlo simulation with no mitigation in place
CP_0=[]; 
% Start a counter for the critical paths for every Monte Carlo simulation with optimal mitigation in place in place
CP_opt=[]; 

% Preallocate memory
Results = zeros(nSimulations, Data.nMitigations+8); 
durations = zeros (Data.nActivities, nSimulations); 

% Initialize progress bar
f = waitbar(0, 'Please wait...', ...
            'Name', 'Simulating mitigation measures',...
            'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

% Status of whether the simulation was aborted
cancelSimulation = 0;
      
for iter = 1 : nSimulations 
    
    %--- Check for clicked Cancel button
    if getappdata(f, 'canceling')
        cancelSimulation = 1;
        break
    end
    
    %--- Update progress bar
    waitbar(iter/nSimulations)
        
    %--- Select new random numbers for each run
    d_i_noCorrelation = d_i_noCorrelation_matrix(:, iter); 
    m_j = m_j_matrix(:, iter);
    d_r = d_r_matrix(:, iter);
    c_j = c_j_matrix(:, iter);
    d_u = d_s_matrix(:, iter);
    
    %--- Evaluate the duration of activities considering the probability of
    % occurence of the risk events and their durations
    
    %--- Bernolli probabability of occurence: 
    % 10% equal to 1 (risk event occurs) and 90% equal to 0(risk event does not occur)   
    r = binornd(1,Data.riskProbability,[Data.nRisks,1]); 
    
    %--- Multiply the duration of the risk events by the bernolli occurence probability: this means that the risk event duration will be applied only when r=1
    d_r = d_r.*r; 
    
    %--- Evaluate the duration of activities considering the probability of
    % occurence of the risk events and their durations
    d_i = d_i_noCorrelation+Data.relActivitiesRisks*d_r+Data.relActivitiesUncertainties*d_u; 
                        
    %--- Store the duration vector
    durations(:,iter) = d_i;

    %--- Evaluation of the duration of any path --> (d_k0, d_kj)
    d_k0 = Data.nodesInPath*d_i; % duration of all paths considering no mitigation measures

    %--- Solve optimization problem
    [x] = opt_mit_lin(Data.nMitigations,...
                      Data.nPaths,...
                      Config.T_target,...
                      Data.nodesInPath,...
                      Data.relActivitiesMitigations,...
                      m_j,d_k0,c_j,...
                      Config.penalty,...
                      Config.incentive);

    % Results and plots  
    
    delta1 = x(Data.nMitigations+1);%delay
    delta2 = x(Data.nMitigations+2);%early finish
    
    %--- Transformation of delta1 and delta2 so that one of them is 0    
    e = min(delta1,delta2);
    delta1 = delta1 - e;
    delta2 = delta2 - e;
    
    x = x(1:Data.nMitigations);
    
    %--- Evaluation of the completion time of the project considering:
    % 1) optimal mitigation strategy 
    % 2) no-measure mitigation strategy
    % 3) all-measure mitigation strategy
    T_opt = max(Data.nodesInPath*(d_i-Data.relActivitiesMitigations*(m_j.*x))); % optimal mitigation strategy
    T_0 = max(Data.nodesInPath*(d_i-Data.relActivitiesMitigations*(m_j.*zeros(Data.nMitigations,1)))); % no mitigation measures
    T_all = max(Data.nodesInPath*(d_i-Data.relActivitiesMitigations*(m_j.*ones(Data.nMitigations,1)))); % all mitigation measures
    
    %--- Identify the critical path(s) when applying:
    % 1) no-measure mitigation strategy
    % 2) optimal mitigation strategy
    % 3) no mitigation strategy
    CP_0 = [CP_0; find(d_k0==max(d_k0))]; % no-measure mitigation strategy        
    d_k_opt = Data.nodesInPath*(d_i-Data.relActivitiesMitigations*(m_j.*x));
    CP_opt = [CP_opt; find(d_k_opt==max(d_k_opt))]; % optimal mitigation strategy

    %--- Evaluation of the cost associated with the 
    % 1) optimal mitigation strategy
    % 2) no-measure mitigation strategy
    % 3) all-measure mitigation strategy
    c_opt = sum(x.*c_j); % optimal mitigation strategy
    c_0 = sum(zeros(Data.nMitigations,1).*c_j); % no-measure mitigation strategy (always equals to zeros)
    c_all = sum(ones(Data.nMitigations,1).*c_j); % all-measure mitigation strategy
    
    %--- Save results
    Results(iter,1:Data.nMitigations)=x; %save the results of x
    Results(iter,Data.nMitigations+1)=T_opt; %save the results of T_opt
    Results(iter,Data.nMitigations+2)=c_opt; %save the results of c_opt
    Results(iter,Data.nMitigations+3)=T_all; %save the results of T_all
    Results(iter,Data.nMitigations+4)=c_all; %save the results of c_all
    Results(iter,Data.nMitigations+5)=T_0; %save the results of T_0
    Results(iter,Data.nMitigations+6)=c_0; %save the results of c_0
    Results(iter,Data.nMitigations+7)=delta1; %save the delta
    Results(iter,Data.nMitigations+8)=delta2; %save the delta   
end

%--- Close progress bar
delete(f)


%--- Compute the correlation matrix of the activities durations
Corr_ii = corrcoef(durations'+0.0001);
for i = 1 : length(Corr_ii)
    for j = 1 : length(Corr_ii)
        if Corr_ii(i,j) < 0.01
            Corr_ii(i,j) = 0;
        end
    end
end
 
end

%% --- Helper functions

function d_i_noCorrelation_parameters = calculate_no_correlation(d_i_total_matrix, d_i_correlation_matrix, d_i_noCorrelation_all)

    % Calculate correlation statistics
    mean_d_i_total_matrix = mean(transpose(d_i_total_matrix));
    variance_d_i_total_matrix = var(transpose(d_i_total_matrix));
    mean_d_i_correlation_matrix = mean(transpose(d_i_correlation_matrix));    
    variance_d_i_correlation_matrix = var(transpose(d_i_correlation_matrix));    

    % Calculate no-correlation statistics
    mean_d_i_noCorrelation_matrix = mean_d_i_total_matrix - mean_d_i_correlation_matrix;
    variance_d_i_noCorrelation_matrix = variance_d_i_total_matrix - variance_d_i_correlation_matrix;
    std_d_i_noCorrelation_matrix = variance_d_i_noCorrelation_matrix .^ 0.5;
    
    % Collect no-correlation parameters
    d_i_noCorrelation_parameters = [d_i_noCorrelation_all(:,1),...
                                d_i_noCorrelation_all(:, 3),...
                                transpose(mean_d_i_noCorrelation_matrix),...
                                transpose(std_d_i_noCorrelation_matrix)];
    
end



function c_j_matrix = mitigation_cost(nMitigations, nSimulations, m_j_all, c_j_all, m_j_matrix)
    
    % Choose the mitigation cost according to the mitigation duration
    c_j_matrix = zeros(nMitigations, nSimulations);
    for i =  1 : nSimulations
        for j = 1 : nMitigations
            if sum(m_j_all(j,3))-sum(m_j_all(j,2))>0 % prevent division by zero
                % Interpolation equation to calculate the cost of mitigation measures
                % according to the chosen mitigation duration
                c_j_matrix(j,i)=c_j_all(j,3)-((m_j_all(j,3)-m_j_matrix(j,i)).*...
                                (c_j_all(j,3)-c_j_all(j,1)))./(m_j_all(j,3)-m_j_all(j,1)); 
            else
                c_j_matrix(j,i) = c_j_all(j,2);
            end
        end
    end
end