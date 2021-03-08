function [collectData, CP_0, CP_opt,Corr_ii] = mitc_simulation(Data, nsimulations, T_pl, penalty, incentive)
% MITC_SIMULATIONa
%
% Inputs:
%
% Outputs:
%
% License:
%
%

%% VARIABLE RENAMING LIST (TEMPORARY)
d_i_total_all = Data.durationActivitiesTotal;
d_i_noCorrelation_all = Data.durationActivitiesNoCorrelation;
d_i_correlation_all = Data.durationActivitiesCorrelation;
N = Data.nActivities;
d_s_all = Data.sharedActivityDurations;
S = Data.nSharedActivities;
m_j_all = Data.mitigatedDuration;
J = Data.nMitigations;
d_r_all = Data.riskEventsDuration;
R = Data.nRisks;
p_r = Data.riskProbability;
c_j_all = Data.mitigationCost;
R_ij = Data.R_ij;
E_ie = Data.E_ie;
P_ki = Data.nodesInPath;
K = Data.nPaths;
U_is = Data.U_is;


%% Draw random numbers 
% tic
%parameters of d_i_noCorrelation distribution obtained from other
%distributions
    d_i_total_matrix = draw_random_numbers(d_i_total_all, N, nsimulations);  
    d_i_correlation_matrix = draw_random_numbers(d_i_correlation_all, N, nsimulations); 

    mean_d_i_total_matrix = mean(transpose(d_i_total_matrix));
    variance_d_i_total_matrix = var(transpose(d_i_total_matrix));
    mean_d_i_correlation_matrix =mean(transpose(d_i_correlation_matrix));    
    variance_d_i_correlation_matrix=var(transpose(d_i_correlation_matrix));    

    mean_d_i_noCorrelation_matrix = mean_d_i_total_matrix - mean_d_i_correlation_matrix;
    variance_d_i_noCorrelation_matrix = variance_d_i_total_matrix - variance_d_i_correlation_matrix;
    std_d_i_noCorrelation_matrix = variance_d_i_noCorrelation_matrix .^ 0.5;

    d_i_noCorrelation_parameters = [d_i_noCorrelation_all(:,1),...
                                    d_i_noCorrelation_all(:, 3),...
                                    transpose(mean_d_i_noCorrelation_matrix),...
                                    transpose(std_d_i_noCorrelation_matrix)];
%     histogram(d_i_total_matrix(7,:),'Normalization','pdf');
%     figure
%     histogram(d_i_correlation_matrix(7,:),'Normalization','pdf');

d_i_noCorrelation_matrix = draw_random_numbers(d_i_noCorrelation_parameters,...
                                                N,...
                                                nsimulations);    
                                                % Independent activity duration
d_s_matrix = draw_random_numbers(d_s_all, S, nsimulations);    % Shared activity durations
m_j_matrix = draw_random_numbers(m_j_all, J, nsimulations);    % Mitigated time
d_r_matrix = draw_random_numbers(d_r_all, R, nsimulations);    % Duration risk event

% figure
% histogram(d_i_noCorrelation_matrix(7,:),'Normalization','pdf');

% toc

%% Choose the mitigation cost according to the mitigation duration
c_j_matrix = zeros(J, nsimulations); %allocate memory to the c_j vector
for i =  1 : nsimulations
    for j= 1 : J
        if sum(m_j_all(j,3))-sum(m_j_all(j,2))>0 % this is to prevent zero in the denominator
            c_j_matrix(j,i)=c_j_all(j,3)-((m_j_all(j,3)-m_j_matrix(j,i)).*...
                            (c_j_all(j,3)-c_j_all(j,1)))./(m_j_all(j,3)-m_j_all(j,1)); %interpolation equation to calculate the cost of mitigation measures
            %according to the chosen mitigation duration
        else
            c_j_matrix(j,i) = c_j_all(j,2);
        end
    end
end

%% Montecarlo simulation
CP_0=[]; %start a counter for the critical paths for every monte carlo simulation with no mitigation in place
CP_opt=[]; %start a counter for the critical paths for every monte carlo simulation with optimal mitigation in place in place
collectData=zeros(nsimulations,J+8); %allocate memory to the results matrix
durations = zeros (N,nsimulations); %to collect activities durations from every iteration

for iter= 1 : nsimulations 
    
    d_i_noCorrelation = d_i_noCorrelation_matrix(:, iter); 
    m_j = m_j_matrix(:, iter);
    d_r = d_r_matrix(:, iter);
    c_j = c_j_matrix(:, iter);
    d_u = d_s_matrix(:, iter);

    
    %--- (c) evaluate the duration of activities considering the probability of
    %occurence of the risk events and their durations
    r = binornd(1,p_r,[R,1]); %bernolli probabability of occurence: 10% equal to 1 (risk event occurs) and 90% equal to 0(risk event does not occur)
    d_r=d_r.*r; %multiply the duration of the risk events by the bernolli occurence probability: this means that the risk event duration will be applied only when r=1
    d_i=d_i_noCorrelation+E_ie*d_r+U_is*d_u; %evaluate the duration of activities considering the probability of
                        %occurence of the risk events and their durations
                        
    %store the duration vector in  durations
    durations(:,iter)=d_i;

    %--- (d) Evaluation of the duration of any path --> (d_k0, d_kj)
        %  duration of all paths when no mitigation strategy is implemented
    d_k0=P_ki*d_i; %duration of all paths considering no mitigation measures

    %--- (h) Optimization problem
    [x]=opt_mit_lin(J,K,T_pl,P_ki,R_ij,m_j,d_k0,c_j,penalty,incentive);

    %% Results and plots  
    
    delta1=x(J+1);%delay
    delta2=x(J+2);%early finish
    
    %transformation of delta1 and delta2 so that one of them is 0
    
    e=min(delta1,delta2);
    delta1=delta1-e;
    delta2=delta2-e;
    
    x=x(1:J);
    %--- (a) Evaluation of the completion time of the project considering the 1)optimal mitigation
    %strategy, 2) no-measure mitigation strategy, and 3)all-measure mitigation
    %strategy
    T_opt=max(P_ki*(d_i-R_ij*(m_j.*x))); %computes the completion time of the project considering the optimal mitigation strategy
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

    collectData(iter,1:J)=x; %save the results of x
    collectData(iter,J+1)=T_opt; %save the results of T_opt
    collectData(iter,J+2)=c_opt; %save the results of c_opt
    collectData(iter,J+3)=T_all; %save the results of T_all
    collectData(iter,J+4)=c_all; %save the results of c_all
    collectData(iter,J+5)=T_0; %save the results of T_0
    collectData(iter,J+6)=c_0; %save the results of c_0
    collectData(iter,J+7)=delta1; %save the delta
    collectData(iter,J+8)=delta2; %save the delta
    

end

%Compute the correlation matrix of the activities durations
Corr_ii = corrcoef(durations'+0.0001);
for i = 1:length(Corr_ii)
    for j=1:length(Corr_ii)
        if Corr_ii(i,j) < 0.01
            Corr_ii(i,j) = 0;
        end
    end
end
 
end
