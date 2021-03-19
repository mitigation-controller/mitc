function listDoubles = unique_doubles_from_cell(data)
% GET_DOUBLES_FROM_CELL - Get all unique values from a cell containing both
% <doubles> and <chars>
%
% Syntax:
% listDoubles = get_doubles_from_cell(cellData)
%
% Inputs:
%   cellData : cell
%
% Outputs:
%   listDoubles : double
%       All unique values as list of doubles
%

% Check data type
isChar = cellfun(@(x) isa(x, 'char'), data);
isDouble = cellfun(@(x) isa(x, 'double'), data);

% Get data
doubleValues = cell2mat(data(isDouble));
charValues = data(isChar);
charToDouble = cellfun(@(x) str2num(x), charValues, 'UniformOutput', false);

% Collect all unique predecessor values
listDoubles = unique([doubleValues; [charToDouble{:}]']);

end