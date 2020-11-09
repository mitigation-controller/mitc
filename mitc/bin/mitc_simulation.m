function output = mitc_simulation(nSimulations, nActivities)
% MITC_SIMULATION
%
% Inputs:
%
% Outputs:
%
% License:
%
%


% Montecarlo simulation
CP_0=[]; %start a counter for the critical paths for every monte carlo simulation with no mitigation in place
CP_opt=[]; %start a counter for the critical paths for every monte carlo simulation with optimal mitigation in place in place
CollectData=zeros(nSimulations,J+6); %allocate memory to the results matrix

% Pre-draw random numbers
d_i = draw_random_numbers(d_i_all, nActivities, nSimulations);  % Activity duration
m_j = draw_random_numbers(m_j_all, nMitigations, nSimulations); % Mitigated time
d_r = draw_random_numbers(d_r_all, nRisks, nSimulations);       % Duration risk event

% Choose the mitigation cost according to the mitigation duration
costMitigation = zeros(nMitigations, 1); %allocate memory to the c_j vector
    for j= 1 : nMitigations
        if sum(m_j_all(j,3))-sum(m_j_all(j,2))>0 % this is to prevent zero in the denominator
            costMitigation(j,1)=c_j_all(j,3)-((m_j_all(j,3)-m_j(j)).*(c_j_all(j,3)-c_j_all(j,1)))./(m_j_all(j,3)-m_j_all(j,1)); %interpolation equation to calculate the cost of mitigation measures
            %according to the chosen mitigation duration
        else
            costMitigation(j,1) = c_j_all(j,2);
        end
    end

for iter= 1 : nSimulations 
      

    %--- (c) evaluate the duration of activities considering the probability of
    %occurence of the risk events and their durations
    r = binornd(1,p_r,[S,1]); %bernolli probabability of occurence: 10% equal to 1 (risk event occurs) and 90% equal to 0(risk event does not occur)
    d_r=d_r.*r; %multiply the duration of the risk events by the bernolli occurence probability: this means that the risk event duration will be applied only when r=1
    d_i=d_i+E_ie*d_r; %evaluate the duration of activities considering the probability of
                        %occurence of the risk events and their durations

    %--- (d) Evaluation of the duration of any path --> (d_k0, d_kj)
        %  duration of all paths when no mitigation strategy is implemented
    d_k0=P_ki*d_i; %duration of all paths considering no mitigation measures

        %duration of all paths when mitigation measure j is implemented
    d_kj=P_ki*(d_i-R_ij*diag(m_j));  %Calculate the duration of every path considering ONLY mitigation measure j and store it in matrix d_kj as a column vector


    %--- (e) Evaluation of the delay of any path with respect to the planned duration T_pl -->(D_k0, D_kj)
    D_k0=max(d_k0-T_pl,0); % delay of all paths when no mitigation strategy is implemented
    D_kj=max(d_kj-T_pl,0); % delay of all paths when mitigation measure j is implemented

    %--- (f) Evaluation of the total time benefit -->(b_j)
    delta_D_kj=D_k0-D_kj; % time benefit on every path k associated with implementing mitigation measure j, with respect to D_k0 
    b_j=sum(delta_D_kj); % the time total benefit (on all paths) associated with implementing mitigation measure j 

    %--- (g) Evaluation of the effectiveness measure associated with implementing mitigation measure j -->(eff_j)
    eff_j=sum(delta_D_kj./c_j',1);

    %--- (h) Optimization problem
    [x]=opt_mit_lin(eff_j,J,K,T_pl,P_ki,R_ij,m_j,d_k0);

    %% Results and plots  
    x=x(1:J);
    %--- (a) Evaluation of the completion time of the project considering the 1)optimal mitigation
    %strategy, 2) no-measure mitigation strategy, and 3)all-measure mitigation
    %strategy
    T_opt=max(P_ki*(d_i-R_ij*(m_j.*x))) %computes the completion time of the project considering the optimal mitigation strategy
    T_all=max(P_ki*(d_i-R_ij*(m_j.*ones(J,1)))); %computes the completion time of the project considering all mitigation measures
    T_0=max(P_ki*(d_i-R_ij*(m_j.*zeros(J,1)))); %computes the completion time of the project with no mitigation measures


    %--- (b) identify the critical path(s) when applying 1)no-measure mitigation strategy, 2) optimal mitigation
    %strategy
        %no mitigation strategy
    CP_0=[CP_0;find(d_k0==max(d_k0))]; %find the critical path(s) and store it/them

        %optimal mitigation strategy
    d_k_opt=P_ki*(d_i-R_ij*(m_j.*x));
    CP_opt=[CP_opt;find(d_k_opt==max(d_k_opt))]; %find the critical path(s) and store it/them  

    %--- (c) Evaluation of the cost associated with the 1)optimal mitigation
    %strategy, 2) no-measure mitigation strategy, and 3)all-measure mitigation
    %strategy
    c_opt=sum(x.*c_j); %computes the cost of the optimal mitigation strategy
    c_all=sum(ones(J,1).*c_j);  %computes the cost of all-measure mitigation strategy
    c_0=sum(zeros(J,1).*c_j); %this is not necessary as it is alway equal to zeros. It computes the cost of implementing no mitigation measure

    %--- (d) Save results

    CollectData(iter,1:J)=x; %save the results of x
    CollectData(iter,J+1)=T_opt; %save the results of T_opt
    CollectData(iter,J+2)=c_opt; %save the results of c_opt
    CollectData(iter,J+3)=T_all; %save the results of T_all
    CollectData(iter,J+4)=c_all; %save the results of c_all
    CollectData(iter,J+5)=T_0; %save the results of T_0
    CollectData(iter,J+6)=c_0; %save the results of c_0
end

