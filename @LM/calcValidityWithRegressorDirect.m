function [validity] = calcValidityWithRegressorDirect(obj,zRegressor,smoothness)
%CALCVALIDITY Summary of this function goes here
%   Detailed explanation goes here
    
%% calc Validity
validity = obj.validityFunction.calcValidity(zRegressor,smoothness);

    
end

