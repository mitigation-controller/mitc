% test conditions
nrows = 5;
ncols = 5;



%% Test: Identity matrix
relation = {1, 2, 3, 4, 5};
expArray = eye(nrows, ncols); % Identity matrix
assert(isequal(find_dependencies(nrows, ncols, relation), expArray))

%% Test: Zero matrix
relation = {0, 0, 0, 0, 0};
expArray = zeros(nrows, ncols); % Zero matrix
assert(isequal(find_dependencies(nrows, ncols, relation), expArray))

%% Test: Exchange matrix
relation = {5, 4, 3, 2, 1};
expArray = flipud(eye(nrows, ncols)); % Exhange matrix
assert(isequal(find_dependencies(nrows, ncols, relation), expArray))
%% Test: Matrix of ones
for i = 1 : nrows
    relation{i} = linspace(1,5,5);
end
expArray = ones(nrows, ncols);
assert(isequal(find_dependencies(nrows, ncols, relation), expArray))