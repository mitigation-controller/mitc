function cellOut = remove_missing(cellIn)
% REMOVE_MISSING - Remove missing values from cell 
%
% Syntax:
% cellOut = remove_missing(cellIn)
%

mask = cellfun(@(x) strcmp(class(x), 'missing'), cellIn, 'UniformOutput', true);
cellIn(mask) = [];
cellOut = cellIn;
end