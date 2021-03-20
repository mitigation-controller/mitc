function h = plot_cost_distribution(distributionType, Results, Data, Config, savename)
% PLOT_PDF_COST - Plot the distribution of the costs
%
% Syntax:
% plot_cost(distributionType, simResults, Data, Config, savename)
%
% Inputs:
%   distributionType : string
%       'pdf' or 'cdf'
%   Results : matrix of doubles
%       Matrix with the simulation results
%   Data : structure
%       Required fields:
%       - nMitigations
%   Config : structure
%      Required fields:
%           - T_target : double
%               Project target duration
%           - mode : string
%              Input for switch statemeent ('Basic' or 'Advanced')
%           - penalty
%           - incentive
%           - savefolder
%   savename : string
%       filename of the exported plot
%

% Check whether requires structure fields exist
expFieldsData = {'nMitigations'};
expFieldsConfig = {'T_target',...
                   'parameterMode',...
                   'penalty',...
                   'incentive',...
                   'savefolder'};
verify_fieldnames(Data, expFieldsData);
verify_fieldnames(Config, expFieldsConfig);


switch Config.parameterMode
    case 'Basic'
        % Calculate the cost distribution without penalty/incentive
        c_opt = Results(:, Data.nMitigations+2);
        c_all = Results(:, Data.nMitigations+4);
    case 'Advanced'
        % Calculate the cost distribution with penalty/incentive
        c_opt = Results(:, Data.nMitigations+2)+...
            Results(:, Data.nMitigations+7) * Config.penalty - ...
            Results(:, Data.nMitigations+8) * Config.incentive;
        
        c_all=Results(:, Data.nMitigations+4)+...
            (max(0,(Results(:, Data.nMitigations+3) - Config.T_target ))) * Config.penalty - ...
            (max(0,(Config.T_target - Results(:, Data.nMitigations+3)))) * Config.incentive;        
end

h = figure;
hold on

% Plot the desired distribution type
switch distributionType
    case 'pdf'
        cost_pdfdist(c_opt,c_all);
    case 'cdf'
        cost_cdfdist(c_opt,c_all);
end
hold off

%--- Export figures
if ~isempty(savename) && ~isempty(savefolder)
    file = [Config.savefolder savename];
    export_fig(h, file)
end
end