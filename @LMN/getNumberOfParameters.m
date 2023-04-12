function n = getNumberOfParameters(obj)
%GETNUMBEROFPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

% linear & nonlinear parameters
nLin = 0;
nNonlin = 0;
for i = 1 : obj.getNumberOfLocalModels
   nLin = nLin + obj.localModels{i}.calcNumberOfLocalParameters;
   nNonlin = nNonlin + obj.localModels{1}.validityFunction.getNumberOfParameters;
end

% Offset
nOffset = 0;
if obj.offset
    nOffset = 1;
end

n = nLin + nNonlin + nOffset;

end

