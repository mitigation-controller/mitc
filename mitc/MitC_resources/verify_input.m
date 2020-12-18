function [status, message] = verify_input(file)
%VERIFY_INPUT 
%
%
%
%

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


