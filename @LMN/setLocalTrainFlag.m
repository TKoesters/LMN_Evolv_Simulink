function obj = setLocalTrainFlag(obj,flagValue)
%SETLOCALADAPTIONFLAG Summary of this function goes here
%   Detailed explanation goes here

for i = 1 : obj.getNumberOfLocalModels
    obj.localModels{i}.trainFlag = flagValue;
end

end

