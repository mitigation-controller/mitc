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
           expSubString = 'Version';
           testCase.verifySubstring(testCase.App.MessageWindow.Value{1}, expSubString,...
               'Expected different initialization message')
           expColor = [1 0.5 0];
           testCase.verifyEqual(testCase.App.Lamp.Color, expColor,...
               'AbsTol', 0.01,...
               'Expected orange as initialization color')
           testCase.verifyFalse(testCase.App.RunsimulationButton.Enable,...
               'Expected the run simulation button to be disabled')                             
       end
       
   end
    
end