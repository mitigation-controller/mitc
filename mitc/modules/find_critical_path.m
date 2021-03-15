function [plannedProjectDuration, criticalPaths] = find_critical_path(paths, durationActivities)
% FIND_CRITICAL_PATHS - Reduce number of possible paths from a
% deterministic analysis
%
% Syntax:
% [plannedProjectDuration, criticalPaths] = select_critical_paths(
%                                           paths, 
%                                           durationActivities)
%
% Inputs:
%   paths : double
%
%   durationActivities : double
%
% Outputs:
%   plannedProjectDuration : double
%       Original project duration
%   criticalPaths : double
%       Selected paths on the basis of a deterministic analysis
%

meanDurationActivities = durationActivities(:,2); 
meanPathDuration = paths * meanDurationActivities;

[plannedProjectDuration, criticalPaths] = max(meanPathDuration);

end