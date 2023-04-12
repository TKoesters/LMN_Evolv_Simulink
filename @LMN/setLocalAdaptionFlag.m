function obj = setLocalAdaptionFlag(obj,flagValue)
%SETLOCALADAPTIONFLAG Summary of this function goes here
%   Detailed explanation goes here

for i = 1 : obj.getNumberOfLocalModels
    obj.localModels{i}.adaptionFlag = flagValue;
end

end

