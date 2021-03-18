function message = type_warning(dataTypes, column, type, expType)
% TYPE_WARNING - Verify data type and generate message
%
% Syntax: 
% message = type_warning(dataTypes, actType, expType)
%
% Inputs:
%   dataTypes : cell
%       Cell with strings of MATLAB classes
%   type : string
%       String of the MATLAB class to look for
%
% Outputs:
%   message : string
%       Warning message with details
%

% Correct for shift in data due to header removal in `import_project.m`
shift = 3;

message = {};
if any(any(contains(dataTypes, type)))
    % Find index of type instances
    [row,~] = find(contains(dataTypes, type));
    row = row + shift;
    
    % Generate a warning message for all found indeces
    for j = 1 : length(row)
        message{end+1,1} = "Warning: Cell(" + num2str(row(j)) +...
                           ", " + num2str(column) +") contains data that is of type " +...
                           type + ". Expected type " + expType + ".";   
    end    
else
    message = [];
end
end