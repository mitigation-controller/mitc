function d_i_noCorrelation_parameters = calculate_no_correlation(d_i_total_matrix, d_i_correlation_matrix, d_i_noCorrelation_all)
% CALCULATE_NO_CORRELATION - 
%
% Syntax:
% d_i_noCorrelation_parameters = calculate_no_correlation(d_i_total_matrix, 
%                                   d_i_correlation_matrix, d_i_noCorrelation_all)
%
% Inputs:
%   d_i_total_matrix
%   d_i_correlation_matrix
%   d_i_noCorrelation_all
%
% Outputs:
%   d_i_noCorrelation_parameters
%

% Calculate correlation statistics
mean_d_i_total_matrix = mean(transpose(d_i_total_matrix));
variance_d_i_total_matrix = var(transpose(d_i_total_matrix));
mean_d_i_correlation_matrix = mean(transpose(d_i_correlation_matrix));    
variance_d_i_correlation_matrix = var(transpose(d_i_correlation_matrix));    

% Calculate no-correlation statistics
mean_d_i_noCorrelation_matrix = mean_d_i_total_matrix - mean_d_i_correlation_matrix;
variance_d_i_noCorrelation_matrix = variance_d_i_total_matrix - variance_d_i_correlation_matrix;
std_d_i_noCorrelation_matrix = abs(variance_d_i_noCorrelation_matrix) .^ 0.5;

% Collect no-correlation parameters
d_i_noCorrelation_parameters = [d_i_noCorrelation_all(:,1),...
                            d_i_noCorrelation_all(:, 3),...
                            transpose(mean_d_i_noCorrelation_matrix),...
                            transpose(std_d_i_noCorrelation_matrix)];
    
end