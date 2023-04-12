function obj = trainGivenStructure(obj)
%TRAINGIVENSTRUCTURE Summary of this function goes here
%   Detailed explanation goes here
  % set Training flag 
    obj.trainFlag = true;

    % call check dimension function if not called yet
    if ~obj.dimensionCheck
        obj = obj.checkDimension();
        obj.dimensionCheck = true;
    end
    
    % redefine local models properties when changed
    obj = obj.redefineLocalModels;
    
    % save data in given Range
    inputTrainRange = obj.inputTrain;
    outputTrainRange = obj.outputTrain;
    
    % norm dataset
    obj = obj.normTrainData;

    % Filter data before Regressors are build
    [obj, xInputFiltered, zInputFiltered] = obj.filterDataForTraining;

    % Build regressors
    obj.xRegressor = obj.localModels{1}.buildRegressor(xInputFiltered,obj.outputTrain);
    obj.zRegressor = obj.localModels{1}.buildZRegressor(zInputFiltered,obj.outputTrain,obj.plotFlag);
    
    % train local Models 
    obj = obj.trainLocalModels;
    
    % put Train data back to inital range
    obj.inputTrain = inputTrainRange;
    obj.outputTrain = outputTrainRange;

    % reset Training flag
    obj = obj.terminateTraining;

end

