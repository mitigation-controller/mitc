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

for i = 1 : rows
    parameters = property(i,:);
    if exist_uncertainty(parameters)
        % Draw a random number from rand_pert
        randomNumbers(i,:) = round(rand_pert(parameters, columns));
    else
        randomNumbers(i,:) = parameters(2);
    end
end


% if size(property,2) == 3 % then use rand_pert_1
%     for i = 1 : rows
%         if exist_uncertainty(property(i,:))
%             % Draw a random number from rand_pert_1
%             randomNumbers(i,:) = round(rand_pert_1(property(i,1),...
%                 property(i,2),...
%                 property(i,3),...
%                 columns));
%         else
%             randomNumbers(i,:) = property(i,2);
%         end
%     end
%     
% else % then use rand_pert_2
%     for i = 1 : rows
%         if exist_uncertainty(property(i,:))
%             % Draw a random number from Pert-Beta distribution
%             randomNumbers(i,:) = round(rand_pert_2(property(i,1),...
%                 property(i,2),...
%                 property(i,3),...
%                 property(i,4),...
%                 columns));
%         else
%             randomNumbers(i,:) = property(i,2);
%         end
%     end
% end

end

% Determine whether property has uncertainty
function out = exist_uncertainty(input)
    out = input(3) - input(1) ~= 0;
end
