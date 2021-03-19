% TEST_MIT_PLAN_MODULAR
%
classdef test_integration < matlab.unittest.TestCase
    
    properties (TestParameter)
        dataCell = load(strcat(pwd, filesep, 'dataCell'));
        dataDouble = load(strcat(pwd, filesep, 'dataDouble'));
    end
    
    methods (Test)
        
        function testData(testCase, dataDouble, dataCell)
            % Test VERIFY_RAW_DATA
            [actStatus, actMessage] = verify_raw_data(dataDouble, dataCell);
            expStatus = 1;
            testCase.verifyEqual(actStatus, expStatus,...
                'Excepted Status = 0');
            
            expMessage = 'Project data verification completed';
            testCase.verifyMatches(actMessage{1}, expMessage,...
                'Expected "Project data verification completed"');
                       
            % Test PARSE_DATA
            [Data, ~, ~] = parse_data(dataDouble, dataCell);
            % Sample some fields
            nMitigations = 19;
            testCase.verifyEqual(Data.nMitigations, nMitigations,...
                'Expected a different number of mitigations')
            nActivities = 38;
            testCase.verifyEqual(Data.nActivities, nActivities,...
                'Expected a different number of activities')
            
            % Test GENERATE_PATHS
            Data = generate_paths(Data);
            nPaths = 20;
            testCase.verifyEqual(Data.nPaths, nPaths,...                
                'Expected a different number of paths')
            linkedActivitiesEnd = [37 38];
            testCase.verifyEqual(Data.linkedActivities(end,:), linkedActivitiesEnd,...                
                'Expected a different linked activities')            
        end    
        
        function testSimulation(testCase, dataDouble, dataCell)
            % Initialize Config structure
            Config.nSimulations = 500;
            Config.T_target = 1466;
            Config.penalty = 8500; 
            Config.incentive = 5000;
            
            % Parse data
            [Data, ~, ~] = parse_data(dataDouble, dataCell);

            % Generate matrix with all paths
            Data = generate_paths(Data);

            % Find the critical path
            Data = find_critical_path(Data);                                            

            % Run simulation
            Results = mitc_simulation(Data, Config);
            expSize = [Config.nSimulations 27];
            testCase.verifySize(Results, expSize,...
                'Expected a different size for Results');
            
            actMean = mean(Results(:,22));
            expMean = 1410;
            testCase.verifyEqual(actMean, expMean,...
                'AbsTol', 100,...
                'Expected different mean duration for all measures');
            
        end
        
    end    
end