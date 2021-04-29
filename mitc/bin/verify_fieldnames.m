function verify_fieldnames(structure, fieldNames)
% VERIFY_FIELDNAMES - Check whether structure.field exists
%
% Syntax:
%  verify_fieldnames(structure, {'field1', 'field2'})
%
% Inputs:
%   structure : structure
%       Structure to be verified    
%   fieldNames : cell
%       Cell containing fieldnames
%
% Outputs:
%   Generate warning if fieldname does not exist
%

for i = 1 : length(fieldNames)
    if ~isfield(structure, fieldNames{i})
        errorString = "The fieldname " + fieldNames{i} + " does not exist";
        error('verify_fieldnames:FieldnameDoesNotExist', errorString)
    end
end

end