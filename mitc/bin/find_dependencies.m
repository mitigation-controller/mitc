function array = find_dependencies(array, relation, iterations)
% FIND_DEPENDENCIES - Find interdependency between two parameters
%
% Syntax:
% array = find_dependencies(array, relation, iterations)
%
% Inputs:
%   array : 
%
%   relation : 
%
%   iterations :
%
%
% Outputs:
%   array : double
%       Array of dependency between parameters
%


    for i = 1 : iterations
            if relation{i} == 0 % If risk event does not affect activity case, do nothing
            elseif isa(relation{i},'double') == 1 % assign interdependency
                array(i, relation{i}) = 1;
            elseif isa(relation{i},'char') == 1
                array(i, str2num(relation{i})) = 1;
            end
    end
    
end