function [variance] = calcLocalParameterVariance(obj,xRegressor,weighting)
%CALCPARAMETERVARIANCE Summary of this function goes here
%   Detailed explanation goes here

variance = diag(inv(xRegressor'*(weighting.*xRegressor)));


end

