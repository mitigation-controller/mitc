% test conditions
nActivities = 5;

%% Test: No activities
R_ii = zeros(nActivities, nActivities);
[nodesInPath, linkedActivities] = generate_paths(R_ii, nActivities);
assert(isempty(linkedActivities))
assert(isempty(nodesInPath))


%% Test: Single path
R_ii = flipud(eye(nActivities, nActivities));
[nodesInPath, linkedActivities] = generate_paths(R_ii, nActivities);
expLinkedActivities = [linspace(1,5,5); linspace(5,1,5)].';
expNodesInPath = [1, 0, 0, 0, 1];
assert(isequal(linkedActivities, expLinkedActivities))
assert(isequal(nodesInPath, expNodesInPath))