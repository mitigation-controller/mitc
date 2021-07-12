function arrayOut = remove_nan(arrayIn)
% REMOVE_NAN - Remove NaN values from matrix
%
% Syntax:
% arrayOut = remove_nan(arrayIn)
%
arrayIn(~any(~isnan(arrayIn), 2),:) = [];
arrayOut = arrayIn;
end