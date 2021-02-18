% TEST_FIND_DEPENDENCIES
%
classdef test_find_dependencies < matlab.unittest.TestCase
    
   properties (TestParameter)
       dim = {5};       
   end
   
   
   methods (Test)
       
        function testIdentityMatrix(testCase, dim)
            relation = num2cell(linspace(1, dim, dim));
            expArray = eye(dim); % Identity matrix
            actArray = find_dependencies(dim, dim, relation);
            testCase.verifyEqual(actArray, expArray,...
               'Expected an identity matrix')
        end
       
        function testZeroMatrix(testCase, dim)
            relation = num2cell(zeros(1, dim));
            expArray = zeros(dim);
            actArray = find_dependencies(dim, dim, relation); % Zero matrix
            testCase.verifyEqual(actArray, expArray,...
               'Expected a zero matrix')
        end
       
        function testExchangeMatrix(testCase, dim)
            relation = num2cell(linspace(dim, 1, dim));
            expArray = flipud(eye(dim)); % Exchange matrix
            actArray = find_dependencies(dim, dim, relation);
            testCase.verifyEqual(actArray, expArray,...
               'Expected an exchange matrix')          
        end
       
        function testOnesMatrix(testCase, dim)
            relation = cell(1,dim);
            for i = 1 : dim
                relation{i} = linspace(1,5,5);
            end
            expArray = ones(dim); % Matrix of ones
            actArray = find_dependencies(dim, dim, relation);
            testCase.verifyEqual(actArray, expArray,...
               'Expected a matrix of ones')                    
        end       
   end        
end