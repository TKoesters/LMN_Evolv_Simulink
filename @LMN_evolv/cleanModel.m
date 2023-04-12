function obj = cleanModel(obj)
%CLEANMODEL Summary of this function goes here
%   Detailed explanation goes here

    %delete data
    obj.inputTrain = [];
    obj.outputTrain = [];
    obj.inputTest = [];
    obj.outputTest = [];
    
    %delete regressors for local models
    for i = 1:obj.getNumberOfLocalModels
        obj.localModels{i}.xRegressor = [];
        obj.localModels{i}.zRegressor = [];
        obj.localModels{i}.invMatrix = [];
    end


    % delete weighting and regressors of global model
    obj.xRegressor = [];
    obj.zRegressor = [];
    obj.weighting = [];

end

