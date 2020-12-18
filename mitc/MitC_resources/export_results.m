function export_results(Config, Data, Results)
%EXPORT_RESULTS
%
%

% Save name
file = strcat(Config.savefolder, 'Data');

% Save files
save(file, 'Config', 'Data', 'Results')

end