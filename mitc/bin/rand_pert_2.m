function [x]=rand_pert_2(a, b, mean, sd, nsimulations)
    % draw_random_pert - Draw a random number from the Beta-Pert
    % distribution
    %
    %
    %

    if mean >= b || mean <= a
        mean = (a+b)/2;
    end
    
    if sd >= mean-a || sd >= b-mean
        sd = min(mean-a, b-mean);
    end
    

    
    alpha=((mean - a) / (b - a) ) * ( (mean - a) * (b - mean) / sd^(2) - 1) ;% First alpha parameter computed using the three points optimistic, most likely, and pessimistic values
    beta=(alpha * (b - mean) / (mean - a));% Second Beta parameter computed using the three points optimistic, most likely, and pessimistic values

    x=randraw('Beta',[a b alpha beta], nsimulations); %draw a random number according to the Beta-Pert distribution

end
