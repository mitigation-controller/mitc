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