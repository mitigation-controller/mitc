% TEST_PARSE_DATA
%
classdef test_parse_data < matlab.unittest.TestCase
    
   properties (TestParameter)
       dataCell = load(strcat(pwd, filesep, 'dataCell'));
       dataDouble = load(strcat(pwd, filesep, 'dataDouble'));
   end
   
   methods (Test)         
       
       function testVariableNames(testCase, dataDouble, dataCell)           
           Data = parse_data(dataDouble, dataCell);
           expVars = {'durationActivities', 'nActivities',...
               'riskEventsDuration', 'riskProbability',...
               'nRisks', 'mitigatedDuration', ...
               'nMitigations', 'mitigationCost',...
               'R_ij', 'E_ie', 'R_ii'};
           actVars = fieldnames(Data);           
           
           % Check whether any expected variable names are missing
           testCase.verifyTrue(all(ismember(actVars, expVars)),...
               'One or more expected variable names are missing');
           % Check whether all variable names are processed
           testCase.verifyTrue(all(ismember(expVars, actVars)),...
               'One or more variable names are not parsed');
       end
       
       function testActivities(testCase, dataDouble, dataCell)
           Data = parse_data(dataDouble, dataCell);
           expNumAct = 38;
           testCase.verifyEqual(Data.nActivities, expNumAct,...
               'Expected a different number of activities')           
       end
       
       function testMitigation(testCase, dataDouble, dataCell)
           Data = parse_data(dataDouble, dataCell);
           expNumMit = 19;           
           testCase.verifyEqual(Data.nMitigations, expNumMit,...
               'Expected a different number of mitigation events')
       end
       
       function testRisks(testCase, dataDouble, dataCell)
           Data = parse_data(dataDouble, dataCell);
           expNumRisks = 19;
           testCase.verifyEqual(Data.nRisks, expNumRisks,...
               'Expected a different number of risk events')
       end
       
       function testRemoveNan(testCase, dataDouble, dataCell)
           Data = parse_data(dataDouble, dataCell);
           nNan = sum(isnan(Data.durationActivities(:)));
           testCase.verifyEqual(nNan, 0,...
               'Expected all nan values to be removed from durationActivities')
           nNan = sum(isnan(Data.riskEventsDuration(:)));
           testCase.verifyEqual(nNan, 0,...
               'Expected all nan values to be removed from riskEventsDuration')
           nNan = sum(isnan(Data.riskProbability(:)));
           testCase.verifyEqual(nNan, 0,...
               'Expected all nan values to be removed from riskProbability')
           nNan = sum(isnan(Data.mitigatedDuration(:)));
           testCase.verifyEqual(nNan, 0,...
               'Expected all nan values to be removed from mitigatedDuration')
           nNan = sum(isnan(Data.mitigationCost(:)));
           testCase.verifyEqual(nNan, 0,...
               'Expected all nan values to be removed from mitigationCost')
       end
       
   end
end