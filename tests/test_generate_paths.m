% TEST_GENERATE_PATHS
%
classdef test_generate_paths < matlab.unittest.TestCase
    
    properties (TestParameter)
        nActivities = {5}; %number of activities
    end
    
    methods (Test)
       
        function testNoActivities(testCase, nActivities)
            S.nActivities = nActivities;
            S.relActivities = zeros(nActivities); 
            S = generate_paths(S);
            testCase.verifyEmpty(S.linkedActivities,...
                'Expected no linked activities')
            testCase.verifyEmpty(S.nodesInPath,...
                'Expected no nodes in the path')            
        end
        
        function testSinglePath(testCase, nActivities)
            S.nActivities = nActivities;
            S.relActivities = flipud(eye(nActivities)); 
            S = generate_paths(S);
            expLinkedActivities = [linspace(1,5,5); linspace(5,1,5)].';
            expNodesInPath = [1, 0, 0, 0, 1];
            testCase.verifyEqual(S.linkedActivities, expLinkedActivities,...
                'Expected different linked activities')
            testCase.verifyEqual(S.nodesInPath, expNodesInPath,...
                'Expected [1, 0, 0, 0, 1] nodes')                       
        end
            
    end
        
end
