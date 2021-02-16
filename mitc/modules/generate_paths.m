function [nodesInPath, linkedActivities] = generate_paths(R_ii, nActivities)
% GENERATE_PATHS - Find all paths and accompanying nodes (activities)
%
% Syntax:
% [nodesInPath, linkedActivities] = generate_paths(R_ii, nActivities)
%
% Inputs:
%   R_ii : double
%      Dependency of activities on predeceding activities
%   nActivities : double
%       Number of activities
%
% Outputs:
%   nodesInPath : double
%       Array of all paths. Each row describes a path with accompanying 
%       activities
%   linkedActivities : double
%       List of linked activities
%

% Find the interdependent activities
[row,col] = find(R_ii); 

% Collect the indices in a two-column matrix that shows which activity 
% depends on which activity (link matrix)
linkedActivities = [col,row]; 

% Use the function allpath.m to find all possible paths from point 1 to
% nActivities
paths = transpose(allpaths(linkedActivities, 1, nActivities)); 
nPaths = length(paths);

% Collect the nodes (activities) per path
nodesInPath = zeros(nPaths, nActivities); 
for k = 1 : nPaths
    nodesInPath(k, paths{k}) = 1;
end
end