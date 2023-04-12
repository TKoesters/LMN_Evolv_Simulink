function numberOfEffParameters = getNumberOfEffParameters(obj)
%GETNUMBEROFPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

 % Build weighting matrices for each local model
 normValidity = obj.calcNormValidity(obj.zRegressor,obj.outputTrain);
 
 nEff = zeros(obj.getNumberOfLocalModels,1);
 for i = 1 : obj.getNumberOfLocalModels
    weighting = normValidity(:,i);
    nEff(i) = obj.localModels{i}.getNumberOfLocalEffParameters(obj.inputTrain,obj.outputTrain,obj.xRegressor,weighting);
 end
 
 % linear parameters
 numberOfEffParametersLocal = sum(nEff);
 
 % nonlinear parameters
 nonlinDimensions = obj.localModels{1}.validityFunction.getNumberOfParameters;
 nonlinParameters = nonlinDimensions * obj.getNumberOfLocalModels;
 
 % n Parameters
 numberOfEffParameters = numberOfEffParametersLocal + nonlinParameters;

end

