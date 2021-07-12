function [x,fval, exitflag]=opt_mit_lin(J,K,T_pl,P_ki,R_ij,m_j,d_k0,c_j,penalty,incentive)
    
%--- Input


%--- Definition of constrains

A=-[(P_ki*R_ij*diag(m_j)'),ones(K,1),-ones(K,1)]; %orig -reduction <= Target+delta1-delta2
b=T_pl-d_k0; %right hand side vector for A2


%--- Boundary constraints
lb = [zeros(1,J),0,0]; %Lower bound is 0 for all variables
ub = [ones(1,J),T_pl*10,T_pl]; %Upper bound is 1 for all variables except the penalty and incentive

%--- Objective function

obj_fun=[(c_j'),penalty,-incentive]; %objective function: summation of cost + penalty - Incentive

%--- Options
intcon=1:J+2; %defines which vvariables are integer (all variables)
options = optimoptions('intlinprog','MaxTime',5);

%--- Optimatization funcion
[x,fval, exitflag,] = intlinprog(obj_fun,intcon,A,b,[],[],lb,ub,[],options); %multi interger linear optimization function

end