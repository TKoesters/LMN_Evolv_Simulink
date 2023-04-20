function [localLinParameters,localCenters,localVariance] = getAllParameters(obj)
%GETALLPARAMETERS Summary of this function goes here
%   Detailed explanation goes here


%% create matrix with local lin parameters
% 
% M = [theta_LM1, theta_LM2, ... , theta_LMn];

localLinParameters = zeros(obj.localModels{1}.calcNumberOfLocalParameters,obj.getNumberOfLocalModels);

for i = 1 : obj.getNumberOfLocalModels
    localLinParameters(:,i) = obj.localModels{i}.theta;
end

%% create matrix with local Centers AND Variances 
% M = [mu_LM1, mu_LM2, ... , mu_LMn];
% S = [sigma_LM1, sigma_LM2, ... , sigma_LMn];
[~,~,nZSpace] = obj.getPosSplits;
localCenters = zeros(nZSpace,obj.getNumberOfLocalModels);

for i = 1 : obj.getNumberOfLocalModels
    localCenters(:,i) = obj.localModels{i}.getCenter;
end

localVariance = zeros(size(localCenters));
for i = 1 : obj.getNumberOfLocalModels
    localVariance(:,i) = obj.localModels{i}.getVariance * obj.smoothness;
end


end

