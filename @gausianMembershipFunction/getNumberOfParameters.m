function numberOfParameter = getNumberOfParameters(obj)
%GETNUMBEROFPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

    numberOfParameter = length(obj.center) + length(obj.variance);

end

