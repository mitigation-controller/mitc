% TEST_VERIFY_FIELDNAMES
%
classdef test_verify_fieldnames < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    methods (Test)
        
        function testFieldnameDoesNotExist(testCase)
            S.a = [];
            fieldnames = {'b'};
            
            testCase.verifyError(@()verify_fieldnames(S, fieldnames),...
                'verify_fieldnames:FieldnameDoesNotExist');
        end           
    end    
end