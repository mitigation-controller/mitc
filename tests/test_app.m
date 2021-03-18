% TEST_APP
%
classdef test_app < matlab.uitest.TestCase
    
   properties
       App
   end
   
   methods (TestMethodSetup)
       function launchApp(testCase)
          testCase.App = MitC_app;
          testCase.addTeardown(@delete, testCase.App);
       end
   end
   
   methods (Test)
       function testInitialization(testCase)           
           expColor = [1 0.5 0];
           testCase.verifyEqual(testCase.App.Lamp.Color, expColor,...
               'AbsTol', 0.01,...
               'Expected orange as initialization color')                         
       end
       
   end
    
end