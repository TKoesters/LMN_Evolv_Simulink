function obj = terminateTraining(obj)
%TERMINATETRAINING Summary of this function goes here
%   Detailed explanation goes here

    obj.trainFlag = false;
    for i = 1 : obj.getNumberOfLocalModels
        obj.localModels{i}.trainFlag = false;
    end

end

