function [dataDouble, dataCell] = import_project(filename)
% import_project - Import project data files
%
%
% Inputs:
%   filename : string
%       filename of the project file to be imported 
%       supported extensions: .xlsx
%   debug : BOOLEAN
%
% Outputs:
%   dataDouble : structure
%   data Cell
%       
% Example:
%
% License:
% 
% 
%------------- BEGIN CODE --------------

%--- Check if file exists
if isfile(filename)
    % file exists
else
    % file does not exist --> warning and return
end

%--- Check file extension
[~, ~, extension] = fileparts(filename);

if strcmp(extension, '.xlsx')
   % supported filetype 
else
   % unsupported filetype --> warning and return
end

%--- Import project datafile if all checks are ok
dataDouble = xlsread(filename);
dataCell = readcell(filename);

%--- Remove headers
dataDouble(1:3,:) = [];
dataCell(1:3,:) = [];


%--- Verify imported data

    
end


