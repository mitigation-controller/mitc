function [nodesInPath, nPaths] = find_worst_cases(nodesInPath, durationActivities, delayRisks, E_ie, plannedProjectDuration)
%FIND_WORST_CASES
%
% Syntax:
% [nodesInPath, nPaths] = find_worst_cases(nodesInPath, durationActivities, delayRisks, E_ie, plannedProjectDuration)

%
% Inputs: 
%   durationActivities : 
%
%   delayRisks :
%
%   E_ie :
%
%   plannedProjectDuration :
%
% Outputs:
%   nodesInPath : double
%
%   nPaths : double
%
%

pessimisticDurationActivities = durationActivities(:,3);
pessimisticDelayRisks = delayRisks(:,3);

% Compute the durations of activities considering the pessimistic durations of activities and risk events
d_i_pess_risk = pessimisticDurationActivities + E_ie * pessimisticDelayRisks; 
 
% pessimitic durations for all paths
pessimisticPathDuration = nodesInPath * d_i_pess_risk;

if length(nodesInPath(:,1)) > 30
    nodesInPath = exclude_path(pessimisticPathDuration, ...
                               plannedProjectDuration,...
                               nodesInPath);
end

nPaths = size(nodesInPath, 1);

end

function nodesInPath = exclude_path(d_k0_pess, T_pl, nodesInPath)
% find paths whose pessimitic durations are less than the project completion time 
[row] = find(d_k0_pess < T_pl); 
nodesInPath(row,:) = []; 
end