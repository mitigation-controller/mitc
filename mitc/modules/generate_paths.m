function Data = generate_paths(Data)
% GENERATE_PATHS - Find all paths and accompanying nodes (activities)
%
% Syntax:
% Data = generate_paths(Data)
%
% Inputs:
%   Data : structure
%       The required inputs are: 
%       - relActivities
%       - nActivities
%
% Outputs:
%   Data : structure
%       Added fields:
%       - nPaths
%       - nodesInPath
%       - linkedActivities
%

% Check whether requires structure fields exist
expFieldNames = {'relActivities', 'nActivities'};
verify_fieldnames(Data, expFieldNames);

% Find the interdependent activities
[row,col] = find(Data.relActivities); 

% Collect the indices in a two-column matrix that shows which activity 
% depends on which activity (link matrix)
linkedActivities = [col,row]; 

% Use the function allpath.m to find all possible paths from point 1 to
% nActivities
paths = transpose(allpaths(linkedActivities, 1, Data.nActivities)); 
nPaths = length(paths);

% Collect the nodes (activities) per path
nodesInPath = zeros(nPaths, Data.nActivities); 
for k = 1 : nPaths
    nodesInPath(k, paths{k}) = 1;
end

% Update Data structure
Data.nPaths = nPaths;
Data.nodesInPath = nodesInPath;
Data.linkedActivities = linkedActivities;

end