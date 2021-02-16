% test conditions
num = 5000;
property = [0 10 100];
PertBeta = draw_random_numbers(property, size(property,1), num);


%% Test: Output size
exp = [1, 5000];
assert(isequal(size(PertBeta), exp), 'Expected a different matrix size')


%% Test: Outliers
assert(min(PertBeta) >= property(1), 'Expected a different minimum value in the distribution')
assert(max(PertBeta) <= property(3), 'Expected a different maximum value in the distribution')


%% Test: Mean of drawn distribution
expMean = (property(1) + 4*property(2) + property(3))/6;
assertWithRelTol(mean(PertBeta), expMean, 'Expected different mean value')


%% Test: Median of drawn distribution
expMedian = (property(1) + 6*property(2) + property(3))/8;
assertWithAbsTol(median(PertBeta), expMedian, 'Expected different median value')


%% Test: Variance of drawn distribution
expMean = (property(1) + 4*property(2) + property(3))/6;
exp_variance = (expMean - property(1))*(property(3) - expMean)/7;
assertWithRelTol(var(PertBeta), exp_variance, 'Expected different variance value')


%% Test: No variability in property
propertyConst = [10 10 10];
PertBetaConst = draw_random_numbers(propertyConst, size(propertyConst,1), 10);

exp_sum = 100;
assert(isequal(sum(PertBetaConst), exp_sum), 'Expected constant values')


function assertWithAbsTol(actVal,expVal,varargin)
% Helper function to assert equality within an absolute tolerance.
% Takes two values and an optional message and compares
% them within an absolute tolerance of 1e-3.
tol = 1e-2;
tf = abs(actVal - expVal) <= tol;
assert(tf, varargin{:});
end

function assertWithRelTol(actVal,expVal,varargin)
% Helper function to assert equality within a relative tolerance.
% Takes two values and an optional message and compares
% them within a relative tolerance of 5%.
relTol = 0.1;
tf = abs(expVal - actVal) <= relTol.*abs(expVal);
assert(tf, varargin{:});
end
