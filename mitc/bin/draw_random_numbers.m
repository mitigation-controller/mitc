function randomNumbers = draw_random_numbers(property, rows, columns)
% DRAW_RANDOM_NUMBERS - Draw a set of random numbers from the Pert-Beta
% distribution
%
% Inputs: 
%   property : array [1,3] or [1,4]
%       3 values: [a, m, b]
%       4 values: [a, b, mean, sd]
%   rows : int
%       number of rows of the matrix    
%   columns : int
%       number of rows of the matrix  
%
% Outputs:
%   randomNumbers : 2D matrix
%       matrix with size [rows, columns] filled with random numbers from
%       the Pert-Beta distribution if applicable
%

randomNumbers = zeros(rows, columns);

for i = 1 : rows
    parameters = property(i,:);
    if exist_uncertainty(parameters)
        % Draw a random number from rand_pert
        randomNumbers(i,:) = round(rand_pert(parameters, columns));
    else
        randomNumbers(i,:) = parameters(2);
    end
end

end

% Determine whether property has uncertainty
function out = exist_uncertainty(input)
    out = input(3) - input(1) ~= 0;
end
