function [x]=rand_pert(a,m,b)
    % draw_random_pert - Draw a random number from the Beta-Pert
    % distribution
    %
    %
    %

    %mu=(a+4*m+b)/6; % mean value
    %sd=(b-a)/2; %standard deviation
    alpha = 1+4*(m-a)/(b-a);% First Beta parameter computed using the three points optimistic, most likely, and pessimistic values
    beta = 1+4*(b-m)/(b-a);% Second Beta parameter computed using the three points optimistic, most likely, and pessimistic values
    x = randraw('Beta',[a b alpha beta],1); %draw a random number according to the Beta-Pert distribution
end
