function [obj,xInputFiltered,zInputFiltered] = filterDataForTraining(obj)
%FILTERDATAFORTRAINING Summary of this function goes here
%   Detailed explanation goes here

obj = obj.initializeFilter;
xInputFiltered = zeros(size(obj.inputTrain));
zInputFiltered = zeros(size(obj.inputTrain));

for i = 1 : length(obj.inputTrain(:,1))
    [obj,xInputFiltered(i,:),zInputFiltered(i,:)] = obj.filterData(obj.inputTrain(i,:));
end

end

