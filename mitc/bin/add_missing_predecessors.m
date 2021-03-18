function [dataCell, nActivities] = add_missing_predecessors(dataCell, nActivities)
% ADD_MISSING_PREDECESSORS
%
% Syntax:
% [dataCell, nActivities] = add_missing_predecessors(dataCell, nActivities)
%
% Inputs:
%   dataCell : cell
%   nActivities : double
%
% Outputs:
%   dataCell : cell
%   nActivities : double
%

% Check data type
isChar = cellfun(@(x) isa(x, 'char'), dataCell(:,6));
isDouble = cellfun(@(x) isa(x, 'double'), dataCell(:,6));

% Get data
doubleValues = cell2mat(dataCell(isDouble,6));
charValues = dataCell(isChar,6);
charToDouble = cellfun(@(x) str2num(x), charValues, 'UniformOutput', false);

% Collect all unique predecessor values
predecessors = unique([doubleValues; [charToDouble{:}]']);

% List of all activity ID's
activities = linspace(1, nActivities, nActivities);
% ID's of missing predecessors
missingPredecessors = find(~ismember(activities, predecessors));

% Add missing predecessors as final activity in dataCell
if ~isempty(missingPredecessors)
    nActivities = nActivities + 1;
    dataCell{nActivities, 1} = nActivities;
    dataCell{nActivities, 2} = 'Auto completion';
    dataCell(nActivities, 3:5) = {0};
    dataCell{nActivities, 6} = num2str(missingPredecessors);
end