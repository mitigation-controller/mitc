function Data = parse_data(dataDouble, dataCell)
% PARSE_DATA - Parse imported project data
%
% Syntax:
% Data = parse_data(dataDouble, dataCell)
%
% Inputs:
%   dataDouble : double
%       Imported project data
%   dataCell : cell
%       Imported project data
%   
% Outputs:
%   Data : structure
%       Structure containing fields with parsed data:
%       - durationActivities
%       - nActivities
%       - riskProbability
%       - nRisks
%       - mitigatedDuration
%       - nMitigations
%       - mitigationCost
%       - R_ij (relation between mitigation measures and activities)
%       - E_ie (relation between risk events and activities)
%       - R_ii (dependency of activities on predeceding activities)
%


%--- Activities duration (optimistic, most likely, and pessimitic) 
Data.durationActivities = remove_nan(dataDouble(:,3:5));
Data.nActivities = size(Data.durationActivities, 1);

%--- Risk events duration (optimistic, most likely, and pessimitic)
Data.riskEventsDuration = remove_nan(dataDouble(:,19:21));

%--- Probability of occurence of risk events
Data.riskProbability = remove_nan(dataDouble(:,23));
Data.nRisks = size(Data.riskProbability,1);

%--- Duration mitigated by every mitigation measure (minimum, most likely, and maximum)
Data.mitigatedDuration = remove_nan(dataDouble(:,9:11));
Data.nMitigations = size(Data.mitigatedDuration, 1);

%--- Cost of the mitigation measures
Data.mitigationCost = remove_nan(dataDouble(:,13:15)); 

%--- Relation matrix indicating upon which activity i each mitigation measure j intervenes
R_ij = zeros(Data.nMitigations, Data.nActivities); 
R_ij_col = dataCell(:,16); 
R_ij = find_dependencies(R_ij, R_ij_col, Data.nMitigations);  
Data.R_ij = transpose(R_ij);

%--- Relation matrix indicating which activity i each risk event e affects (delays)
E_ie = zeros(Data.nRisks, Data.nActivities); 
E_ie_col = dataCell(:,22); 
E_ie = find_dependencies(E_ie, E_ie_col, Data.nRisks);  
Data.E_ie = transpose(E_ie);

%--- Relationship matrix between mitigation measures and activities
R_ii=zeros(Data.nActivities, Data.nActivities);
R_ii_col=dataCell(:,6); 
Data.R_ii = find_dependencies(R_ii, R_ii_col, Data.nActivities);

% Helper functions
function arrayOut = remove_nan(arrayIn)
    arrayIn(~any(~isnan(arrayIn), 2),:) = [];
    arrayOut = arrayIn;
end

end