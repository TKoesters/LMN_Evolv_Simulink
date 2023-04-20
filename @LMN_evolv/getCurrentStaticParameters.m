function [staticTheta,localVariance,localCenters] = getCurrentStaticParameters(obj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% get static parameters
numberOfLocalStaticParameters = obj.dimIn + int16(obj.offset);
staticTheta = zeros(numberOfLocalStaticParameters,obj.getNumberOfLocalModels);
for i = 1 : obj.getNumberOfLocalModels
   staticTheta(:,i) = obj.localModels{i}.calcStaticParameters(numberOfLocalStaticParameters,obj.dimIn);
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

