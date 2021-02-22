function [x]=rand_pert_1(a,m,b,nsimulations)
    % draw_random_pert - Draw a random number from the Beta-Pert
    % distribution
    %
    %
    %
    mean=(a+4*m+b)/6; % mean value
    sd=(b-a)/6; %standard deviation
    %alpha = 1+4*(m-a)/(b-a);% First Beta parameter computed using the three points optimistic, most likely, and pessimistic values
    %beta = 1+4*(b-m)/(b-a);% Second Beta parameter computed using the three points optimistic, most likely, and pessimistic values
    
    alpha=((mean - a) / (b - a) ) * ( (mean - a) * (b - mean) / sd^(2) - 1) ;% First alpha parameter computed using the three points optimistic, most likely, and pessimistic values
    beta=(alpha * (b - mean) / (mean - a));% Second Beta parameter computed using the three points optimistic, most likely, and pessimistic values

    x = randraw('Beta',[a b alpha beta],nsimulations); %draw a random number according to the Beta-Pert distribution
end

