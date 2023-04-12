function obj = updateRegInformation(obj,RegOptions)
%UPDATEREGINFORMATION Summary of this function goes here
%   Detailed explanation goes here

for i = 1 : length(obj.dynamicModels)
    if ~isempty(obj.dynamicModels{i})
        obj.dynamicModels{i} = obj.dynamicModels{i}.updateRegInformation(RegOptions,i);
    end
end

obj.RegOptions = RegOptions;

end