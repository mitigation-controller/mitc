clc
clear 
close all
tic
%diary Optimal_Diary
rng('default') %For reproducibility
addpath('bin')

%% Definition of parameters and variables

%--- number of Monte Carlo simulations -->(nsimulations)
nsimulations=1000;

%--- Planned/target duration of the project -->(T_pl)
T_pl=1466;

%--- Load data from the spreadsheet -->
filename = '..\data\Case study.xlsx';
Data1=xlsread(filename);Data2=readcell(filename);
Data1(1:3,:)=[];Data2(1:3,:)=[];

%--- Activities duration (optimisatic, most likely, and pessimitic) -->(d_i_all)
d_i_all=Data1(:,3:5);% load the cells related to the activities duration
d_i_all(~any(~isnan(d_i_all), 2),:)=[]; % remove rows with Nan value

%--- Number of activities
N=size(d_i_all,1);

%--- Risk events duration (optimisatic, most likely, and pessimitic) -->(d_r_all)
d_r_all=Data1(:,19:21);% load the cells related to the risk events duration
d_r_all(~any(~isnan(d_r_all), 2),:)=[]; % remove rows with Nan value

%--- Probability of occurence of risk events
p_r=Data1(:,23);% load the cells related to the risk events duration
p_r(~any(~isnan(p_r), 2),:)=[]; % remove rows with Nan value
  
%--- Number of risk events
S=size(d_r_all,1);

%--- Duration mitigated by every mitigation measure (minimum, most likely, and maximum) -->(m_j_all)
m_j_all=Data1(:,9:11); % load the cells related to the time mitigated
m_j_all(~any(~isnan(m_j_all), 2),:)=[]; % remove rows with Nan value

%--- Number of mitigation measures
J=size(m_j_all,1); 

%--- Cost of the mitigation measures -->(c_j)
c_j_all=Data1(:,13:15); % load the cells related to the mitigation measures costs
c_j_all(~any(~isnan(c_j_all), 2),:)=[]; % remove rows with Nan value

%--- Relation matrix indicating upon which activity i each mitigation measure j intervenes -->(R_ij)
R_ij=zeros(J,N); %create JxN matrix: relationships between mitigation measures and activities (the matrix is to be inversed later)
R_ij_col=Data2(:,16); % load the cells related to relationships between mitigation measures and activities

for j=1:J % for-loop to fill the R_ij matrix
    if R_ij_col{j}==0 %check if R_ij_col{j} is zero. that is, measure j does not affect any activity i. In this case, do nothing
    elseif isa(R_ij_col{j},'double')==1 %check if R_ij_col{j} is a number. that is, measure j affects one activity i.
        R_ij(j,R_ij_col{j})=1; %assign interdependency between measure j and activity i
    elseif isa(R_ij_col{j},'char')==1 %check if R_ij_col{j} is a character. that is, measure j affects more than one activity.
        R_ij(j,str2num(R_ij_col{j}))=1; %assign interdependency between measure j and activities
    end
end
R_ij=R_ij'; %inverse the matrix

%--- Relation matrix indicating which activity i each risk event e effects (delays) -->(E_ie)
E_ie=zeros(S,N); %create SxN matrix: relationships between risk events and activities (the matrix is to be inversed later)
E_ie_col=Data2(:,22); % load the cells related to relationships between risk events and activities

for s=1:S % for-loop to fill the E_ie matrix
    if E_ie_col{s}==0 %check if E_ie_col{s} is zero. that is, risk event s does not not affect any activity i. In this case, do nothing
    elseif isa(E_ie_col{s},'double')==1 %check if E_ie_col{s} is a number. that is, risk event s affects one activity i.
        E_ie(s,E_ie_col{s})=1; %assign interdependency between risk event s and activity i
    elseif isa(E_ie_col{s},'char')==1 %check if E_ie_col{s} is a character. that is, risk event s affects more than one activity.
        E_ie(s,str2num(E_ie_col{s}))=1; %assign interdependency between risk event s and activities
    end
end
E_ie=E_ie'; %inverse the matrix


%% Generating a subset of most critical paths assuming pessimistic durations of activities-->{P_ki}
R_ii=zeros(N,N); %create NxN matrix: relationships between mitigation measures and activities
R_ii_col=Data2(:,6); % load the cells related to relationships between mitigation measures and activities

for i=1:N % for-loop to fill the R_ii matrix
    if R_ii_col{i}==0 %check if R_ij_col{j} is zero. that is, measure j does not affect any activity i. In this case, do nothing
    elseif isa(R_ii_col{i},'double')==1 %check if R_ij_col{j} is a number. that is, measure j affects one activity i.
        R_ii(i,R_ii_col{i})=1; %assign interdependency between measure j and activity i
    elseif isa(R_ii_col{i},'char')==1 %check if R_ij_col{j} is a character. that is, measure j affects more than one activity.
        R_ii(i,str2num(R_ii_col{i}))=1; %assign interdependency between measure j and activities
    end
end

[row,col]=find(R_ii); %find the interdependent activities
A=[col,row]; %store the indices in a two-column matrix that shows which activity depends on which activity (link matrix)
P_all=allpaths(A,1,N)'; %use the function all path to find all possible paths from point 1 to point N

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
d_i_pess_risk=d_i_pess+E_ie*d_r_pess; %compute the durations of activities considering the pessimistic durations of activities and risk events

d_k0_pess=P_ki*d_i_pess_risk; % pessimitic durations for all paths

if length(P_ki(:,1))>30
    [row]=find(d_k0_pess<T_pl); % find paths whose pessimitic durations are less than the project completion time 
    P_ki(row,:)=[]; % exclude path whose durations are less than the project completion time
end

K=length(P_ki(:,1)); %number of analyzed paths

%find the critical path under deterministic analysis
d_i_ml=d_i_all(:,2); % most likely durations for all activities
d_k0_ml=P_ki*d_i_ml; % most likely durations for all paths

[T_orig, P_cr_0]=max(d_k0_ml); %T_orig is the duration as in the original plan


%% Plot the network

%computing weights for every edge: weight of an edge is equal to the duration
%of the precedent node/activity
for k=1:length(A)
    w(k)=Data2(A(k,1),3);
end
w=cell2mat(w);

%create the graph
figure
G = digraph(A(:,1),A(:,2),w);
p = plot(G,'Layout','layered','Direction','right','AssignLayers','asap','EdgeLabel',G.Edges.Weight);
%% Montecarlo simulation
CP_0=[]; %start a counter for the critical paths for every monte carlo simulation with no mitigation in place
CP_opt=[]; %start a counter for the critical paths for every monte carlo simulation with optimal mitigation in place in place
CollectData=zeros(nsimulations,J+6); %allocate memory to the results matrix

for iter=1:nsimulations % Starts monte carlo simulation
%--- (a) Choosing a random combination of d_i_all, M-j_all, and d_r_all according Beta-Pert Distribution  -->  (d_i, m_j, d_r)

d_i=zeros(N,1); %allocate memory to the d_i vector
for i=1:N
    if d_i_all(i,3)-d_i_all(i,1)>0 %check if there is uncertainty
            d_i(i,1)=round(rand_pert(d_i_all(i,1),d_i_all(i,2),d_i_all(i,3))); %choose a (rounded) random number according to the Beta-Pert distribution for the...
                                                                        % ...duration of every activity
    else
        d_i(i,1)=d_i_all(i,2); %if there is no uncertainty, then apply the expected duration
    end
end

m_j=zeros(J,1); %allocate memory to the m_j vector
for j=1:J
    if m_j_all(j,3)-m_j_all(j,1)>0  %check if there is uncertainty
        m_j(j,1)=round(rand_pert(m_j_all(j,1),m_j_all(j,2),m_j_all(j,3))); %choose a (rounded) random number according to the Beta-Pert distribution for the...
                                                                  % ...time mitigated by every measure
    else
        m_j(j,1)=m_j_all(j,3); %if there is no uncertainty, then apply the expected duration
    end
end

d_r=zeros(S,1); %allocate memory to the d_r vector
for s=1:S
    if d_r_all(s,3)-d_r_all(s,1)>0 %check if there is uncertainty
        d_r(s,1)=round(rand_pert(d_r_all(s,1),d_r_all(s,2),d_r_all(s,3))); %choose a (rounded) random number according to the Beta-Pert distribution for the...
                                                                  % ...duration of every risk event
    else
        d_r(s,1)=d_r_all(s,2); %if there is no uncertainty, then apply the expected duration
    end
end

%--- (b) choose the mitigation cost according to the mitigation duration

c_j=zeros(J,1); %allocate memory to the c_j vector
for j=1:J
    if sum(m_j_all(j,3))-sum(m_j_all(j,2))>0 % this is to prevent zero in the denominator
        c_j(j,1)=c_j_all(j,3)-((m_j_all(j,3)-m_j(j)).*(c_j_all(j,3)-c_j_all(j,1)))./(m_j_all(j,3)-m_j_all(j,1)); %interpolation equation to calculate the cost of mitigation measures
        %according to the chosen mitigation duration
    else
        c_j(j,1)=c_j_all(j,2);
    end
end

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

%--- (e) compute the average cost of the optimal mitigation strategies
avg_cost_opt=mean(CollectData(:,J+2));

%--- (f) frequency of mitigation measures
freq_j=(sum(CollectData(:,1:J)))';freq_j=freq_j./nsimulations*100;
    %Bar chart for freq_j
    figure
    b=bar(freq_j,'FaceColor','flat');
    b.CData = [0.7 0.7 0.7];
    xlabel('Mitigation measure ID','FontSize',20);
    ylabel('Percentage','FontSize',20);
    bx = gca;
    bx.FontSize = 16; 
    bx.YGrid = 'on';
    xticks(1 : N-1)
    set(bx,'TickLength',[0, 0])
    hold off

%--- (g) frequency of critical paths with no mitigation measures
freq_k0=tabulate(CP_0);freq_k0=freq_k0(:,3);
freq_k0=[freq_k0 ;zeros(K-numel(freq_k0),1)];

%--- (h) frequency of critical paths with optimal mitigation measures
freq_k_opt=tabulate(CP_opt);freq_k_opt=freq_k_opt(:,3);
freq_k_opt=[freq_k_opt ;zeros(K-numel(freq_k_opt),1)];
  
%     %Bar chart for freq_k0 and freq_k_opt
    figure
    b=bar([freq_k0,freq_k_opt],'FaceColor','flat');
    b(1).CData = [0 0 0];
    b(2).CData = [0.7 0.7 0.7];
    xlabel('Project path ID','FontSize',20);
    ylabel('Percentage','FontSize',20);
    legend('No Mit','Tentative');
    bx = gca;
    bx.FontSize = 16;
    bx.YGrid = 'on';
    xticks(1 : K)
    set(bx,'TickLength',[0, 0])
    hold off



%--- (i) frequency of mitigation strategies
[Mu,ia,ic] = unique(round(CollectData(:,1:J)), 'rows');           % Unique Values By Row, Retaining Original Order
h = accumarray(ic, 1);                                               % Count Occurrences
maph = h(ic);                                                        % Map Occurrences To ?ic? Values
freq_x = [CollectData(:,1:J), maph];
freq_x=unique(round(freq_x),'rows');
freq_x=[freq_x,freq_x(:,J+1)./sum(freq_x(:,J+1))*100];

X=length(freq_x(:,1)); %number of combinations

%--- (j) mitigation measure-mitigation strategy criticality analysis

%creating an X by J matrix where elements are sorted by their highest
%percentages, freq_x and freq_j
if X>1
    freq_x_sort=freq_x;
    freq_x_sort=sortrows(freq_x_sort(1:X,:),J+1,{'descend'});
    freq_x_sort=[freq_x_sort;[freq_j',0,0];[1:J,0,0]];
    freq_x_sort=freq_x_sort';
    freq_x_sort=sortrows(freq_x_sort(1:J,:),X+1,{'descend'});
    freq_x_sort=freq_x_sort';
    freq_x_sort=[freq_x_sort,[sort([freq_x(:,J+2);0;0],'descend')]];

    %relationship between the mitigation measures used and mitigation strategies covered

    mit_comb_x=tril(ones(J)); %lower triangle matrix of ones
    mit_comb_x=[zeros(1,J);mit_comb_x];
    cum_freq=zeros(J+1,1); %create a matrix to fill it with the cumulative results
    for j=1:J+1
        for x=1:X
            if sum(find((mit_comb_x(j,:)-freq_x_sort(x,1:J))<0))==0
                cum_freq(j)=cum_freq(j)+freq_x_sort(x,J+1);
            end
        end
    end
        
    cum_freq_x=[mit_comb_x,cum_freq];
 
    crit_j=freq_x_sort(X+2,1:J);
    C=zeros(1,J);
    for j=1:J
        C_crit(j)=c_j_all(crit_j(j),2);
    end
    C_crit_cum=cumsum(C_crit);
        
end

%--- (k)Critical path-activities criticality analysis
%before optimization
CP_0_ki=(tabulate(CP_0));
CP_0_ki=CP_0_ki(:,2);
CP_0_ki=[CP_0_ki ;zeros(K-numel(CP_0_ki),1)];
CP_0_ki=(CP_0_ki.*P_ki);

freq_0_i=sum(CP_0_ki); %frequency of every activity being on a critical path before optimization
freq_0_i=([freq_0_i;freq_0_i/length(CP_0)*100])';%percentage of every activity being on a critical path before optimization

%after optimization
CP_opt_ki=(tabulate(CP_opt));
CP_opt_ki=CP_opt_ki(:,2);
CP_opt_ki=[CP_opt_ki ;zeros(K-numel(CP_opt_ki),1)];
CP_opt_ki=(CP_opt_ki.*P_ki);

freq_opt_i=sum(CP_opt_ki); %frequency of every activity being on a critical path after optimization
freq_opt_i=([freq_opt_i;freq_opt_i/length(CP_opt)*100])';%percentage of every activity being on a critical path after optimization

%     Bar chart for freq_0_i and freq_opt_i
    figure
    b=bar([freq_0_i(1:N-1,2),freq_opt_i(1:N-1,2)],'grouped','FaceColor','flat');
    b(1).CData = [0 0 0];
    b(2).CData = [0.7 0.7 0.7];
    xlabel('Activity ID','FontSize',20);
    ylabel('Percentage','FontSize',20);
    legend('No Mit','Tentative');
    bx = gca;
    bx.FontSize = 16; 
    bx.YGrid = 'on';
    xticks(1 : N-1)
    set(bx,'TickLength',[0, 0])
    hold off
    
%--- (l) plots
figure

y_opt=CollectData(:,J+1);
cdfplot(y_opt)
hold on
y_all=CollectData(:,J+3);
cdfplot(y_all)
hold on
y_0=CollectData(:,J+5);
cdfplot(y_0)
hold on
y_0_nouncertainty=T_orig*ones(nsimulations,1);
hold off

fitting(y_opt,y_all,y_0,y_0_nouncertainty,T_pl);

%--- (m) Cost distribution
c_opt=CollectData(:,J+2);
c_all=CollectData(:,J+4);

figure
cost_pdfdist(c_opt,c_all);
figure
cost_cdfdist(c_opt,c_all);

    %calculate the 5% and 95 percentiles
c_all_5=prctile(c_all,5);
c_all_95=prctile(c_all,95);

c_opt_5=prctile(c_opt,5);
c_opt_95=prctile(c_opt,95);


%% Closure
toc
%save('OptimalSolution.mat')
%diary off


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Optimization problem definition

function [x,fval, exitflag]=opt_mit_lin(eff_j,J,K,T_pl,P_ki,R_ij,m_j,d_k0)
%--- Input
delta_1=1e-8; %a small value to give less weight to the second obejctive function term. 
                                             %it is relative to the first term in the objective function
delta_2=1e8; %a large value to give more weight to the third obejctive function term. 
                                            %it is relative to the first term in the objective function

%--- Definition of constrains
A1=[diag(1./(exp(eff_j./(max(eff_j)+1e-8)))),zeros(J,1)]; % a consatraint to prevent zero effectiveness measures. 
                                     %The additional zeros is to account for the
                                     %extra variable 
b1=ones(J,1)-1e-8; %right hand side vector for A1 (1 e-8 is to consider < instead of <=)

A2=-[(P_ki*R_ij*diag(m_j)'),ones(K,1)]; %the duration of every critical path should be less than or equal than the
                                           %planned duration. The ones at
                                           %the end are to account for the
                                           %additional variable
b2=T_pl-d_k0; %right hand side vector for A2

A=[A1;A2]; %Left hand side constraint matrix
b=[b1;b2]; %Right hand side constraint vector

%--- Boundary constraints
lb = zeros(1,J+1); %Lower bound is 0 for all variables
ub = [ones(1,J),1e6]; %Upper bound is 1 for all variables

%--- Objective function
obj_fun=[(1./(exp(eff_j./(max(eff_j)+1e-8)))-delta_1*m_j'),delta_2]; %Objective function: the inverse of efficiency   
%obj_fun=[(1./(exp(eff_j))),delta_2];                                                    %multiplied by the variables should
                                                    %be minimum + a factor that chooses the
                                                    %strategy that reduces the duration the most
                                                    %in case of equal efficiency strategies.
                                                    %+ a factor that optimize for the best
                                                    %strategy possible if the first two
                                                    %objectives cannot be attained

%--- Options
intcon=1:J+1; %defines which vvariables are integer (all variables)
options = optimoptions('intlinprog','MaxTime',5);

%--- Optimatization funcion
[x,fval, exitflag,] = intlinprog(obj_fun,intcon,A,b,[],[],lb,ub,[],options); %multi interger linear optimization function

end
%--- Nested functions



%% Other functions

%--- Identifying the most critical paths and ranking them in criticality order -->{P_ki}


%--- Choose a random duration for every activity/mitigation measure according to the Beta-Pert distribution
function [x]=RandPert(a,m,b)
%mu=(a+4*m+b)/6; % mean value
%sd=(b-a)/2; %standard deviation
alpha=1+4*(m-a)/(b-a);% First Beta parameter computed using the three points optimistic, most likely, and pessimistic values
beta=1+4*(b-m)/(b-a);% Second Beta parameter computed using the three points optimistic, most likely, and pessimistic values
x=randraw('Beta',[a b alpha beta],1); %draw a random number according to the Beta-Pert distribution
end

%--- Evaluation of the duration of any path -->(d_k0, d_kj)


%--- Evaluation of the delay of any path with respect to the planned duration T_pl -->(D_k0, D_kj)


%--- Evaluation of the time benefit on every path k associated with implementing mitigation measure j, with respect to D_k0 -->(delta_D_kj)


%--- Evaluation of the total benefit (on all paths) associated with implementing mitigation measure j -->(b_j)


%--- Evaluation of the effectiveness measure associated with implementing mitigation measure j -->(eff_j)





