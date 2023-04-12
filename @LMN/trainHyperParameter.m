function [obj] = trainHyperParameter(obj,hyperParametersInit)
%TRAINHYPERPARAMETER Summary of this function goes here
%   Detailed explanation goes here

costFunc = @(hyperparameters)optFunc(obj,hyperparameters);

optHyperparameters = fmincon(costFunc,hyperParametersInit,[],[],[],[],obj.getHyperparameterLowerBound,obj.getHyperparameterUpperBound);

obj = obj.setHyperparameters(optHyperparameters);
obj = obj.trainLOLIMOT;


end


function J = optFunc(obj,hyperparameters)
    obj = obj.setHyperparameters(hyperparameters);
    obj = obj.trainLOLIMOT;
    J = obj.calcTestError;
end