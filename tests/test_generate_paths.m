% TEST_GENERATE_PATHS
%
classdef test_generate_paths < matlab.unittest.TestCase
    
    properties (TestParameter)
        nAct = {5}; %number of activities
    end
    
    methods (Test)
       
        function testNoActivities(testCase, nAct)
            R_ii = zeros(nAct); % activity dependence matrix
            [nodesInPath, linkedActivities] = generate_paths(R_ii, nAct);
            testCase.verifyEmpty(linkedActivities,...
                'Expected no linked activities')
            testCase.verifyEmpty(nodesInPath,...
                'Expected no nodes in the path')            
        end
        
        function testSinglePath(testCase, nAct)
           R_ii = flipud(eye(nAct)); % activity dependence matrix
           [actNodesInPath, actLinkedActivities] = generate_paths(R_ii, nAct);
           expLinkedActivities = [linspace(1,5,5); linspace(5,1,5)].';
           expNodesInPath = [1, 0, 0, 0, 1];
           testCase.verifyEqual(actLinkedActivities, expLinkedActivities,...
               'Expected different linked activities')
           testCase.verifyEqual(actNodesInPath, expNodesInPath,...
               'Expected [1, 0, 0, 0, 1] nodes')                       
        end
            
    end
        
end
