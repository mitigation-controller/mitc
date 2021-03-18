function [dataCell, dataDouble, nActivities] = find_missing_predecessors(dataCell, dataDouble, nActivities)
% FIND_MISSING_PREDECESSORS
%
% Syntax:
% [predecessors, activityDuration, nActivities] = find_missing_predecessors(dataCell, dataDouble, nActivities)
%
% Inputs:
%   dataCell : cell
%   dataDouble : matrix of doubles
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
doubleValues = cell2mat(dataCell(isDouble, 6));
charValues = dataCell(isChar, 6);
charToDouble = cellfun(@(x) str2num(x), charValues, 'UniformOutput', false);

% Collect all unique predecessor values
uniquePredecessors = unique([doubleValues; [charToDouble{:}]']);

% List of all activity ID's
activities = linspace(1, nActivities, nActivities);
% ID's of missing predecessors
missingPredecessors = find(~ismember(activities, uniquePredecessors));

% Add missing predecessors as final activity in dataCell and dataDouble
if ~isempty(missingPredecessors)
   % Update number of activities
   nActivities = nActivities + 1;
   % Update predecessors list
   dataCell{nActivities, 1} = nActivities;
   dataCell{nActivities, 2} = 'Auto completion';
   dataCell(nActivities, 3:5) = {0};
   dataCell{nActivities, 6} = num2str(missingPredecessors);
   for i = 7 : size(dataCell,2)
      if isempty(dataCell{nActivities, i})
         dataCell{nActivities, i} = missing; 
      end       
   end
   
   % Update activity duration matrix
   dataDouble(nActivities, 1) = nActivities;
   dataDouble(nActivities, 2) = NaN;
   dataDouble(nActivities, 3:5) = 0;
   dataDouble(nActivities, 6) = NaN;
   for i = 7 : size(dataDouble,2)
      if dataDouble(nActivities, i) == 0
         dataDouble(nActivities, i) = NaN; 
      end       
   end
end
end