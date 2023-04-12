function obj = redefineLocalModels(obj)
%REDEFINELOCALMODELS Summary of this function goes here
%   Detailed explanation goes here


for i = 1 : obj.getNumberOfLocalModels
    obj.localModels{i}.xDynInputDelay = obj.xDynInputDelay;
    obj.localModels{i}.xDynOutputDelay = obj.xDynOutputDelay;
    obj.localModels{i}.xStaticInputFunc = obj.xStaticInputFunc;

    obj.localModels{i}.zDynOutputDelay = obj.zDynOutputDelay;
    obj.localModels{i}.zDynInputDelay = obj.zDynInputDelay;
    obj.localModels{i}.zStaticInputFunc = obj.zStaticInputFunc;

    obj.localModels{i}.xDeadTimes = obj.xDeadTimes;
    obj.localModels{i}.zDeadTimes = obj.zDeadTimes;
end

end

