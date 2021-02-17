function run_tests
%RUNTESTS
%
%
%
%

% Add current folder plus all subfolders to the path.
folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Run all tests
results = runtests(pwd,'IncludeSubfolders',true);
disp(results)


end