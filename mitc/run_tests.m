function result = run_tests
%RUNTESTS
%
%
% Resources:
% https://nl.mathworks.com/help/matlab/ref/matlab.unittest.plugins.codecoverageplugin-class.html


import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoverageReport
import matlab.unittest.plugins.codecoverage.CoberturaFormat


% Add current folder plus all subfolders to the path.
% folder = fileparts(which(mfilename)); 
addpath(genpath(pwd));

% Create test suite
testFolder = strcat(pwd, '\tests');
suite = TestSuite.fromFolder(testFolder);
runner = TestRunner.withTextOutput;
reportFolder = strcat(testFolder, '\Reports\');
if ~exist(reportFolder, 'dir')
    mkdir(reportFolder)
end


% Prepare HTML format output
reportFileHTML = 'CoverageResults.html';
pluginHTML = CodeCoveragePlugin.forFolder(pwd,...
    'Producing', CoverageReport(reportFolder, 'MainFile', reportFileHTML),...
    'IncludeSubFolders', true);
runner.addPlugin(pluginHTML);

% Prepare XML format output
reportFileXML = strcat(reportFolder, 'CoverageResults.xml');
reportFormat = CoberturaFormat(reportFileXML);
pluginXML = CodeCoveragePlugin.forFolder(pwd,...
    'Producing', reportFormat,...
    'IncludeSubFolders', true);
runner.addPlugin(pluginXML);

result = runner.run(suite);
% open(strcat(reportFolder, reportFileHTML))
end