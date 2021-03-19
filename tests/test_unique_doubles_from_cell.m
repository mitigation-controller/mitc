% TEST_UNIQUE_DOUBLES_FROM_CELL
%
classdef test_unique_doubles_from_cell < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    methods (Test)
        
        function testEmptyCell(testCase)
            data = {};
            actList = unique_doubles_from_cell(data);
            testCase.verifyEmpty(actList,...
                'Expected an empty list');
        end       
                
        function testDoubles(testCase)
            data = {1,2,3,4};
            expList = [1; 2; 3; 4];
            actList = unique_doubles_from_cell(data);
            testCase.verifyEqual(actList, expList,...
                'Expected a list of doubles');
        end       
        
        function testCell(testCase)
            data = {'1 2' ,'3, 4'};
            expList = [1; 2; 3; 4];
            actList = unique_doubles_from_cell(data);
            testCase.verifyEqual(actList, expList,...
                'Expected a list of doubles');
        end   
        
        function testDoubleAndCell(testCase)
            data = {'1 2' ,3, 4};
            expList = [1; 2; 3; 4];
            actList = unique_doubles_from_cell(data);
            testCase.verifyEqual(actList, expList,...
                'Expected a list of doubles');
        end
        
    end    
end