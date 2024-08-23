%% Run Regression with participant wide

load('AGRF_001_Results.mat')

id = find(~any(Coeffs));

Coeffs(id) = [];

AvgCoeffs = mean(Coeffs,1);


