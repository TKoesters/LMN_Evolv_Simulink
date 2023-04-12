function [variances] = calcParameterVariances(obj)
%CALCPARAMETERVARIANCES Summary of this function goes here
%   Detailed explanation goes here

variances = zeros(obj.localModels{1}.calcNumberOfLocalParameters,obj.getNumberOfLocalModels);

normValidity = obj.calcNormValidity(obj.inputTrain,obj.outputTrain);


for i = 1 : obj.getNumberOfLocalModels
    variances(:,i) = obj.localModels{i}.calcLocalParameterVariance(obj.xRegressor,normValidity(:,i));
end


end

