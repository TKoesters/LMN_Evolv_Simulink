function [staticTheta,localCenters,localVariance] = getCurrentStaticParameters(obj,numberOfLocalModels,numberOfLocalStaticParameters)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    numberOfLocalModels = obj.getNumberOfLocalModels;
    dimIn = obj.dimIn;
    offset = obj.offset;
    numberOfLocalStaticParameters = dimIn + offset;
end

%% get static parameters
staticTheta = zeros(numberOfLocalStaticParameters,numberOfLocalModels);
for i = 1 : numberOfLocalModels
   staticTheta(:,i) = obj.localModels{i}.calcStaticParameters(numberOfLocalStaticParameters,obj.dimIn,obj.outputRange,obj.inputRanges);
end

% add global offset when present
if obj.globalOffsetFlag
    staticTheta(1,:) = staticTheta(1,:) + obj.globalOffset;
end

% calc global gain when present
if obj.globalGainFlag
    staticTheta(2:end,:) = staticTheta(2:end,:) * obj.globalGain; 
end

%% create matrix with local Centers AND Variances 
% M = [mu_LM1, mu_LM2, ... , mu_LMn];
% S = [sigma_LM1, sigma_LM2, ... , sigma_LMn];
%[~,~,nZSpace] = obj.getPosSplits;
localCenters = zeros(numberOfLocalStaticParameters-1,numberOfLocalModels); % this only hold when all inputs are present in zSpace 

for i = 1 : numberOfLocalModels
    localCenters(:,i) = obj.localModels{i}.getCenter;
end

localVariance = zeros(size(localCenters));
for i = 1 :numberOfLocalModels
    localVariance(:,i) = obj.localModels{i}.getVariance * obj.smoothness;
end

end

