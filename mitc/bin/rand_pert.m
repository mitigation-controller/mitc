function dist = rand_pert(property, N)
    % DRAW_RANDOM_PERT - Draw a random number from the Beta-Pert
    % distribution
    %
    % Syntax: [x] = rand_pert(property, nsimulations)
    %
    % Inputs:
    %   property : 1D array of doubles
    %       Property of Pert-Beta distribution. Can be length 3 or 4.
    %   N : double
    %       Number of randowm numbers to draw
    %
    % Outputs:
    %   dist : 1D array of doubles
    %       Array of random numbers from the Pert-Beta distribution
    %

    %--- Parse distribution parameters
    switch length(property)
        case 3         
            % Assign elements in property to separate variables
            p = num2cell(property);
            [a, m, b] = deal(p{:});
            
            % Calculate mean and standard deviation
            mean = (a+4*m+b)/6;
            sd = (b-a)/6;                    
            
        case 4   
            % Assign elements in property to separate variables
            p = num2cell(property);
            [a, b, mean, sd] = deal(p{:});
            
            % Verify mean
            if mean >= b || mean <= a
                mean = (a+b)/2;
            end

            % Verify standard deviation
            if sd >= mean-a || sd >= b-mean
                sd = min((mean-a)/2, (b-mean)/2);
            end                          
    end
    
    %--- First alpha parameter computed using the three points optimistic, 
    % most likely, and pessimistic values
    alpha = ((mean - a) / (b - a) ) * ( (mean - a) * (b - mean) / sd^(2) - 1) ;

    %--- Second Beta parameter computed using the three points optimistic, 
    % most likely, and pessimistic values
    beta = (alpha * (b - mean) / (mean - a));
    
    %--- Draw a random number according to the Beta-Pert distribution
    dist = randraw('Beta',[a b alpha beta], N); 

end
