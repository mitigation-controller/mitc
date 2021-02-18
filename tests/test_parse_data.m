% TEST_PARSE_DATA
%
classdef test_parse_data < matlab.unittest.TestCase
    
   properties (TestParameter)
       dataCell = load(strcat(pwd, '\dataCell'));
       dataDouble = load(strcat(pwd, '\dataDouble'));
   end
   
   methods (Test)
       
       function testActivities(testCase, dataDouble, dataCell)
           Data = parse_data(dataDouble, dataCell);
           expNumActivities = 38;
           testCase.verifyEqual(Data.nActivities, expNumActivities,...
               'Expected a different number of activities')           
       end
       
   end
    
end