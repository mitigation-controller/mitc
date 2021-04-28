function [status, message] = verify_filepath(file)
%VERIFY_FILEPATH - Check the selected file
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
status = true;

% Check whether file is empty
if isempty(file)
    message = "Input is empty.";
    status = false;
    return 
end

% Check whether the file is a string
if ~ischar(file)
    message = "File selection aborted...";
    status = false;
    return
end

% Check whether the file exists
if ~isfile(file)
    message = "File is not found.";
    status = false;
    return
end

% Check file extension
[~,~,extension] = fileparts(file);
switch lower(extension)
    case '.xlsx'   
        message = file + " is selected." ;
    otherwise
        message = "File type (" + extension + ") is not supported.";
        status = false;
        return
end


