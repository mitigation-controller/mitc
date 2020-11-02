function matrixOut = find_dependencies(matrixIn, relation, iterations)
    % FIND_DEPENDENCIES - Find interdependency between two variables
    %
    % Inputs:
    %
    % Outputs:
    %
    %

    for i = 1 : iterations
            if relation{i} == 0 % If risk event does not not affect activity case, do nothing
            elseif isdouble(relation{i}) % assign interdependency
                matrixIn(i, relation{i}) = 1;
            elseif ischar(relation{i})
                matrixIn(i, str2num(relation{i})) = 1;
            end
    matrixOut = matrixIn;        
    end       
    
end