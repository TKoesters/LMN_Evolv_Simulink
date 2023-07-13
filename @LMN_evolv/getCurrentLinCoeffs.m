function [theta] = getCurrentLinCoeffs(obj,method)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

normValidity = obj.calcNormValidity(obj.zRegressor);
theta = zeros(max(obj.indexInput,[],"all"),1);
switch method
    case 'best'
        % find most active model
        [~,maxIndex] = max(normValidity);
        theta = obj.localModels{maxIndex}.theta;
    case 'combined'
        for i = 1 : obj.getNumberOfLocalModels
            % old theta = theta + obj.localModels{i}.theta * normValidity(i)/obj.getNumberOfLocalModels;
            theta = theta + obj.localModels{i}.theta * normValidity(i);
        end

    otherwise

end

end