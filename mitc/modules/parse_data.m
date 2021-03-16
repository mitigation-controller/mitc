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
%       - durationActivitiesTotal
%       - nActivities
%       - riskEventsProbability
%       - nRisks
%       - mitigatedDuration
%       - nMitigations
%       - mitigationCost
%       - R_ij (relation between mitigation measures and activities)
%       - E_ie (relation between risk events and activities)
%       - R_ii (dependency of activities on predeceding activities)
%       - U_is (Relation matrix indicating which activity i shares a shared
%       activity s)
%
% For more information on variable naming, see: 
% https://github.com/mitigation-controller/mitc/wiki/Variable-Names
%


%--- Activities total duration (optimistic, most likely, and pessimitic) 
Data.durationActivitiesTotal = remove_nan(dataDouble(:,3:5));
Data.nActivities = size(Data.durationActivitiesTotal, 1);

%--- durations of shared activities  (optimistic, most likely, and pessimitic)
Data.sharedUncertainties = remove_nan(dataDouble(:,26:28));
Data.nSharedUncertainties = size(Data.sharedUncertainties,1);

%--- Relation matrix indicating which activity i shares a shared activity s -->(U_is)
U_is_relation = remove_missing(dataCell(:,29)); 
U_is = find_dependencies(Data.nSharedUncertainties, Data.nActivities, U_is_relation);
Data.relActivitiesUncertainties = transpose(U_is);

%--- Activities shared durations (only the shared part; the part of the duration that is causing correlation)
Data.durationActivitiesCorrelation = Data.relActivitiesUncertainties * Data.sharedUncertainties;

%--- Activities duration without correlation with other activities (removing the shared durations)
Data.durationActivitiesNoCorrelation = Data.durationActivitiesTotal - ...
                                    Data.durationActivitiesCorrelation ;

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
R_ij_relation = remove_missing(dataCell(:,16)); 
R_ij = find_dependencies(Data.nMitigations, Data.nActivities, R_ij_relation);  
Data.relActivitiesMitigations = transpose(R_ij);

%--- Relation matrix indicating which activity i each risk event e affects (delays)
E_ie_relation = remove_missing(dataCell(:,22));
E_ie = find_dependencies(Data.nRisks, Data.nActivities, E_ie_relation);
Data.relActivitiesRisks = transpose(E_ie);

%--- Relationship matrix between activities and activities
R_ii_relation = dataCell(:,6);
Data.relActivities = find_dependencies(Data.nActivities, Data.nActivities, R_ii_relation);

end

%--- Helper functions
function arrayOut = remove_nan(arrayIn)
    arrayIn(~any(~isnan(arrayIn), 2),:) = [];
    arrayOut = arrayIn;
end

function cellOut = remove_missing(cellIn)
    mask = cellfun(@(x) strcmp(class(x), 'missing'), cellIn, 'UniformOutput', true);
    cellIn(mask) = [];
    cellOut = cellIn;
end