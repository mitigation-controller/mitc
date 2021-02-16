function array = find_dependencies(nrows, ncols, relation)
% FIND_DEPENDENCIES - Find interdependency between two parameters
%
% Syntax:
% array = find_dependencies(nrows, ncols, relation)
%
% Inputs:
%   nrows : double
%       Number of parameters events
%   ncols : double
%       Number of parameters events
%   relation : double
%
% Outputs:
%   array : double
%       Array of relation between parameters
%
% Example:
% R_ij = find_dependencies(nMitigation, nActivities, R_ij_relation)
% 

% Check inputs
assert(nrows == length(relation), 'Number of relations does not match number of events')

% Create relation matrix
array = zeros(nrows, ncols);

for i = 1 : nrows
    if relation{i} == 0 % If risk event does not affect activity case, do nothing
    elseif isa(relation{i},'double') == 1 % assign interdependency
         array(i, relation{i}) = 1;
    elseif isa(relation{i},'char') == 1
         array(i, str2num(relation{i})) = 1;        
    end
        
end




% function array = find_dependencies(array, relation, iterations)
% % FIND_DEPENDENCIES - Find interdependency between two parameters
% %
% % Syntax:
% % array = find_dependencies(array, relation, iterations)
% %
% % Inputs:
% %   array : 
% %
% %   relation : 
% %
% %   iterations :
% %
% %
% % Outputs:
% %   array : double
% %       Array of dependency between parameters
% %
% 
% 
%     for i = 1 : iterations
%             if relation{i} == 0 % If risk event does not affect activity case, do nothing
%             elseif isa(relation{i},'double') == 1 % assign interdependency
%                 array(i, relation{i}) = 1;
%             elseif isa(relation{i},'char') == 1
%                 array(i, str2num(relation{i})) = 1;
%             end
%     end
%     
% end