function out = parse_data(dataDouble, dataCell)
% PARSE_DATA - Parse imported data
%
% Inputs:
%   dataDouble : double
%       filename of the .xlsx file to be imported
%   dataCell : cell
%       
%
% Outputs:
%   Data : structure
%       
% 
%
% License:
% 
% 
%------------- BEGIN CODE --------------

%--- Activities duration (optimistic, most likely, and pessimitic) 
out.durationActivities = remove_nan(dataDouble(:,3:5));
out.nActivities = size(out.durationActivities, 1);

%--- Risk events duration (optimistic, most likely, and pessimitic)
out.riskEventsDuration = remove_nan(dataDouble(:,19:21));

%--- Probability of occurence of risk events
out.riskProbability = remove_nan(dataDouble(:,23));
out.nRisks = size(out.riskProbability,1);

%--- Duration mitigated by every mitigation measure (minimum, most likely, and maximum)
out.mitigatedDuration = remove_nan(dataDouble(:,9:11));
out.nMitigations = size(out.mitigatedDuration, 1);

%--- Cost of the mitigation measures
out.mitigationCost = remove_nan(dataDouble(:,13:15)); 

%--- Relation matrix indicating upon which activity i each mitigation measure j intervenes
R_ij = zeros(out.nMitigations, out.nActivities); 
R_ij_col = dataCell(:,16); 
R_ij = find_dependencies(R_ij, R_ij_col, out.nMitigations);  
out.R_ij = transpose(R_ij);

%--- Relation matrix indicating which activity i each risk event e effects (delays)
E_ie = zeros(out.nRisks, out.nActivities); 
E_ie_col = dataCell(:,22); 
E_ie = find_dependencies(E_ie, E_ie_col, out.nRisks);  
out.E_ie = transpose(E_ie);

%--- Relationship matrix between mitigation measures and activities
R_ii=zeros(out.nActivities, out.nActivities);
R_ii_col=dataCell(:,6); 
out.R_ii = find_dependencies(R_ii, R_ii_col, out.nActivities);

function arrayOut = remove_nan(arrayIn)
    arrayIn(~any(~isnan(arrayIn), 2),:) = [];
    arrayOut = arrayIn;
end

end