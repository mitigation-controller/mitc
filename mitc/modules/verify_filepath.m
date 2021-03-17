function [status, message] = verify_filepath(file)
%VERIFY_INPUT - Check the selected file
%
% Input:
%   file : string
%       absolute filepath of the project data
% 
% Outputs:
%   status : boolean
%       Report the status of filepath
%   message : string
%       Output message
%

% Initialize outputs
status = false;
message = [];

% Check whether file is empty
if isempty(file)
    message = 'Input is empty';
    return 
end

% Check whether the file is a string
if ~ischar(file)
    message = 'File selection aborted...';
    return
end

% Check whether the file exists
if ~isfile(file)
    message = 'File is not found';
    return
end

% Check file extension
[~,~,extension] = fileparts(file);
switch lower(extension)
    case '.xlsx'        
        status = true;        
    otherwise
        message = ['File type (', extension, ') is not supported'];
        status = false;
        return
end


