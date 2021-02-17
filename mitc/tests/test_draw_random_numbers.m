% TEST DRAW_RANDOM_NUMBERS
classdef test_draw_random_numbers < matlab.unittest.TestCase

    properties (TestParameter)
        N = {5000};
        args = {[0 10 100]};
        PertBeta = {draw_random_numbers(...
            test_draw_random_numbers.args{1},...
            size(test_draw_random_numbers.args{1},1),...
            test_draw_random_numbers.N{1})};
    end
    

    % Test Method Block
    methods (Test)
    
        function testOutputSize(testCase, N, PertBeta)    
            expSize = [1, N];
            actSize = size(PertBeta);
            testCase.verifyEqual(actSize, expSize,...
                'Expected a different distribution size')
        end
                
        function testOutlierRange(testCase, PertBeta, args)
            % Test min outlier
            expMin = args(1);
            actMin = min(PertBeta);                        
            testCase.verifyGreaterThanOrEqual(actMin, expMin,...
                'Expected a different minimum value in the distribution')   
            % Test max outlier
            expMax = args(3);
            actMax = max(PertBeta);     
            testCase.verifyLessThanOrEqual(actMax, expMax,...
                'Expected a different maximum value in the distribution')
        end
        
        function testMeanDistribution(testCase, PertBeta, args)            
            expMean = (args(1) + 4*args(2) + args(3))/6;
            actMean = mean(PertBeta);
            testCase.verifyEqual(actMean, expMean,...
                'RelTol', 0.1,... 
                'Expected different mean value')
        end
        
        function testMedianDistribution(testCase, PertBeta, args)
           expMedian = (args(1) + 6*args(2) + args(3))/8;
           actMedian = median(PertBeta);
           testCase.verifyEqual(actMedian, expMedian, ...
               'RelTol', 0.05,...
               'Expected different median value') 
        end
        
        function testVarianceDistribution(testCase, PertBeta, args)
           expMean = (args(1) + 4*args(2) + args(3))/6;
           expVar =  (expMean - args(1))*(args(3) - expMean)/7;
           actVar = var(PertBeta);
           testCase.verifyEqual(actVar, expVar,...
               'RelTol', 0.1,...
               'Expected different variance value')
        end
                
        function testNoVariance(testCase)
            propertyConst = [10 10 10];
            PertBetaConst = draw_random_numbers(propertyConst, size(propertyConst,1), 10);
            expSum = 100;
            actSum = sum(PertBetaConst);
            testCase.verifyEqual(actSum, expSum,...
                'Expected constant values')            
        end
        
    end
end

