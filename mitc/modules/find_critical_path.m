function Data = find_critical_path(Data)
% FIND_CRITICAL_PATHS - Reduce number of possible paths from a
% deterministic analysis
%
% Syntax:
% Data = select_critical_paths(Data)
%
% Inputs:
%   Data : structure
%       Required inputs:
%       - nodesInPath
%       - durationActivitiesTotal
%
% Outputs:
%   Data : structure
%       Added fields
%       - T_orig (Original project duration)
%       - initialCriticalPath
%


% Check whether requires structure fields exist
expFieldNames = {'nodesInPath', 'durationActivitiesTotal'};
verify_fieldnames(Data, expFieldNames);

meanDurationActivities = Data.durationActivitiesTotal(:,2); 
meanPathDuration = Data.nodesInPath * meanDurationActivities;

[T_orig, initialCriticalPath] = max(meanPathDuration);

% Update Data structure
Data.T_orig = T_orig;
Data.initialCriticalPath = initialCriticalPath;

end