function [x,fval, exitflag]=opt_mit_lin(eff_j,J,K,T_pl,P_ki,R_ij,m_j,d_k0,c_j,penalty,incentive)
    
%--- Input


%--- Definition of constrains
A1=[diag(1./(exp(eff_j./(max(eff_j)+1e-8)))),zeros(J,1),zeros(J,1)]; % a consatraint to prevent zero effectiveness measures. 
                                     %The additional zeros is to account for the
                                     %extra variable 
b1=ones(J,1)-1e-8; %right hand side vector for A1 (1 e-8 is to consider < instead of <=)

A2=-[(P_ki*R_ij*diag(m_j)'),ones(K,1),-ones(K,1)]; %orig -reduction <= Target+delta1-delta2
b2=T_pl-d_k0; %right hand side vector for A2

A=[A1;A2]; %Left hand side constraint matrix
b=[b1;b2]; %Right hand side constraint vector

%--- Boundary constraints
lb = [zeros(1,J),0,0]; %Lower bound is 0 for all variables
ub = [ones(1,J),1000,1466]; %Upper bound is 1 for all variables except delta 1 and delta 2
    %%%%%%correct boundary consditions of delta1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--- Objective function

obj_fun=[(c_j'),penalty,-incentive]; %objective function: summation of cost + penalty - Incentive

%--- Options
intcon=1:J+2; %defines which vvariables are integer (all variables)
options = optimoptions('intlinprog','MaxTime',5);

%--- Optimatization funcion
[x,fval, exitflag,] = intlinprog(obj_fun,intcon,A,b,[],[],lb,ub,[],options); %multi interger linear optimization function

end