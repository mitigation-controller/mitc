function randomNumbers = draw_random_numbers(property, rows, columns)
% DRAW_RANDOM_NUMBERS - Draw a set of random numbers from the Pert-Beta
% distribution
%
% Inputs: 
%   rows : int
%       number of rows of the matrix    
%   columns : int
%       number of rows of the matrix  
%   property : array [1,3]
%       3 values: optimisitic, most likely, and pessimitic expectation
%
% Outputs:
%   randomNumbers : 2D matrix
%       matrix with size [rows, columns] filled with random numbers from
%       the Pert-Beta distribution if applicable
%

randomNumbers = zeros(rows, columns);

for j = 1 : columns
    for i = 1 : rows
        if existUncertainty(property(i,:))
            % Draw a random number from Pert-Beta distribution
            randomNumbers(i,j) = round(rand_pert(property(i,1),...
                                                 property(i,2),...
                                                 property(i,3))); 
        else
            randomNumbers(i,j) = property(i,2);
        end
    end
end
end

% Determine whether property has uncertainty
function out = existUncertainty(input)
    if input(3) - input(1) > 0
        out = true;
    else
        out = false;
    end
end