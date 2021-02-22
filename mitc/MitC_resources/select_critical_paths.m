function [T_orig, P_cr_0, K] = select_critical_paths(P_ki, d_i_all, d_r_all, E_ie)
    % FIND_CRITICAL_PATHS - 
    %
    % Inputs:
    %   R_ii :
    %   N : 
    %   d_i_all : 
    %   E_ie :    
    %
    % Outputs:
    %   T_orig
    %   P_ki
    %   K
    %   A

    %--- Verify input
    % Check that data exists and is of the correct type
          
    %--- Module #
    %store only the most/potential critical paths assuming 1) pessimistic durations of
    %activities and 2) maximum delay due to risk: 
    d_i_pess=d_i_all(:,3); % pessimitic durations for all activities
    d_r_pess=d_r_all(:,3); % pessimitic durations for all risk events
    d_i_pess_risk = d_i_pess + E_ie * d_r_pess; %compute the durations of activities considering the pessimistic durations of activities and risk events

    d_k0_pess=P_ki*d_i_pess_risk; % pessimitic durations for all paths

    if length(P_ki(:,1))>30
        [row]=find(d_k0_pess<T_pl); % find paths whose pessimitic durations are less than the project completion time 
        P_ki(row,:)=[]; % exclude path whose durations are less than the project completion time
    end

    K = length(P_ki(:,1)); %number of analyzed paths

    %find the critical path under deterministic analysis
    d_i_ml=d_i_all(:,2); % most likely durations for all activities
    d_k0_ml=P_ki*d_i_ml; % most likely durations for all paths

    [T_orig, P_cr_0]=max(d_k0_ml); %T_orig is the duration as in the original plan




end