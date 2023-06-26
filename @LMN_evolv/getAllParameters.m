function [localLinParameters,localCenters,localVariance] = getAllParameters(obj)
%GETALLPARAMETERS Summary of this function goes here
%   Detailed explanation goes here


%% create matrix with local lin parameters
% 
% M = [theta_LM1, theta_LM2, ... , theta_LMn];

% CODE GENERATION 
% localLinParameters = zeros(obj.localModels{1}.calcNumberOfLocalParameters,obj.getNumberOfLocalModels);
localLinParameters = zeros(length(obj.localModels{1}.theta),obj.getNumberOfLocalModels);

for i = 1 : obj.getNumberOfLocalModels
    localLinParameters(:,i) = obj.localModels{i}.theta;
end

% multiply all parameters with gain
localLinParameters = localLinParameters * obj.globalGain;

% add global offset to each local offset
localLinParameters(1,:) = localLinParameters(1,:) + obj.globalOffset; 



%% create matrix with local Centers AND Variances 
% M = [mu_LM1, mu_LM2, ... , mu_LMn];
% S = [sigma_LM1, sigma_LM2, ... , sigma_LMn];
% CODE GENERATION
% [~,~,nZSpace] = obj.getPosSplits;
nZSpace = length(obj.localModels{1}.getCenter);
localCenters = zeros(nZSpace,obj.getNumberOfLocalModels);

for i = 1 : obj.getNumberOfLocalModels
    localCenters(:,i) = obj.localModels{i}.getCenter;
end

localVariance = zeros(size(localCenters));
for i = 1 : obj.getNumberOfLocalModels
    localVariance(:,i) = obj.localModels{i}.getVariance * obj.smoothness;
end


end

