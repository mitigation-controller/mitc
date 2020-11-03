function [T_orig, P_cr_0] = find_critical_paths(inputs)
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
    % Check that data is structure
    % Check that required data exists
       
    [row,col] = find(R_ii); %find the interdependent activities
    A = [col,row]; %store the indices in a two-column matrix that shows which activity depends on which activity (link matrix)
    P_all = transpose(allpaths(A,1,N)); %use the function all path to find all possible paths from point 1 to point N

    P_ki=zeros(length(P_all),N); % create matrix P-K to store the paths

    % for-loop to fill the P_ki matrix
    for k=1:length(P_all)
        for i=1:length(P_all{k})
            P_ki(k,P_all{k}(i))=1;
        end
    end

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