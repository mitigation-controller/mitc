% TEST_TYPE_ERROR
%
classdef test_type_error < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    methods (Test)
        
        function testCorrectDataType(testCase)
            dataTypes = {1, 2, 3, 4};
            type = 'char';
            message = type_error(dataTypes, [], type, []);
            testCase.verifyEmpty(message, ...
                'Expected an empty message')
        end
        
        function testIncorrectDataType(testCase)
            dataTypes = {'one', 2, 3, 4};
            type = 'char';
            message = type_error(dataTypes, [], type, []);
            testCase.verifyNotEmpty(message, ...
                'Expected an error message')
        end        
    end    
end