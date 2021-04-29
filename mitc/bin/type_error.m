function message = type_error(listCell, column, type, expType)
% TYPE_WARNING - Verify data type and generate message
%
% Syntax: 
% message = type_error(dataTypes, column, type, expType)
%
% Inputs:
%   cellList : cell
%       Cell
%   column : double
%       Column number that is inspected
%   type : string
%       String of the MATLAB class that would raise an error
%   expType : string
%       String of the expected MATLAB class
%
% Outputs:
%   message : string
%       Warning message with details. Returns empty cell when data types are
%       correct
%

% Correct for shift in data due to header removal in `import_project.m`
shift = 3;

message = {};

% Get all datatypes in the data column
dataTypes = cellfun(@(x) class(x), listCell, 'UniformOutput', false);

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