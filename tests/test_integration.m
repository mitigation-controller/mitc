% TEST_INTEGRATION
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
        
%         function testSimulation(testCase, dataDouble, dataCell)
%             % Initialize Config structure
%             Config.nSimulations = 100;
%             Config.T_target = 1466;
%             Config.penalty = 8500; 
%             Config.incentive = 5000;
%             
%             % Parse data
%             [Data, ~, ~] = parse_data(dataDouble, dataCell);
% 
%             % Generate matrix with all paths
%             Data = generate_paths(Data);
% 
%             % Find the critical path
%             Data = find_critical_path(Data);                                            
% 
%             % Run simulation
%             Results = mitc_simulation(Data, Config);
%             expSize = [Config.nSimulations 27];
%             testCase.verifySize(Results, expSize,...
%                 'Expected a different size for Results');
%             
%             actMean = mean(Results(:,22));
%             expMean = 1410;
%             testCase.verifyEqual(actMean, expMean,...
%                 'AbsTol', 100,...
%                 'Expected different mean duration for all measures');
%             
%         end
         
        function testPlotting(testCase, dataDouble, dataCell)
            % Initialize Config structure
            Config.nSimulations = 100;
            Config.T_target = 1466;
            Config.penalty = 8500; 
            Config.incentive = 5000;
            Config.parameterMode = 'Advanced';
            Config.savefolder = '';
            
            % Parse data
            [Data, ~, dataCell] = parse_data(dataDouble, dataCell);

            % Generate matrix with all paths
            Data = generate_paths(Data);

            % Find the critical path
            Data = find_critical_path(Data);                                            

            % Run simulation
            [Results, CP_0, CP_opt, ~, ~] = mitc_simulation(Data, Config);
            fig_1 = plot_network(Data.linkedActivities, dataCell, [], []);

            fig_2 = plot_freq_mitigation(Results, Data, Config.nSimulations, [], []);

            fig_3 = plot_freq_paths(CP_0, CP_opt, Data.nPaths, [], []);                            

            fig_4 =  plot_freq_activity(CP_0, CP_opt, Data.nPaths,...
                                        Data.nodesInPath, Data.nActivities,...
                                        [], []);

            fig_5 = plot_cdf(Results, Data.nMitigations,Data.T_orig,...
                        Config.T_target, Config.nSimulations, [], []);

            fig_6 = plot_cost_distribution('cdf', Results, Data, Config, []);
            fig_7 = plot_cost_distribution('pdf', Results, Data, Config, []);
            
            % Verify handles
            testCase.verifyTrue(exist('fig_1') && ishandle(fig_1),...
                'Expected figure 1')
            testCase.verifyTrue(exist('fig_2') && ishandle(fig_2),...
                'Expected figure 2')
            testCase.verifyTrue(exist('fig_3') && ishandle(fig_3),...
                'Expected figure 3')
            testCase.verifyTrue(exist('fig_4') && ishandle(fig_4),...
                'Expected figure 4')
            testCase.verifyTrue(exist('fig_5') && ishandle(fig_5),...
                'Expected figure 5')
            testCase.verifyTrue(exist('fig_6') && ishandle(fig_6),...
                'Expected figure 6')
            testCase.verifyTrue(exist('fig_7') && ishandle(fig_7),...
                'Expected figure 7')
            
            close all
        end
        
    end    
end