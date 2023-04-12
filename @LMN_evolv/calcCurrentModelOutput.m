function [obj,output] = calcCurrentModelOutput(obj)
%CALCCURRENTOUTPUT Summary of this function goes here
%   Detailed explanation goes here

% get validity from all local models
normValidity = obj.calcNormValidity(obj.zRegressor);

% get output from all local models
outputLM = zeros(1,obj.getNumberOfLocalModels);
for i = 1 : obj.getNumberOfLocalModels
    outputLM(1,i) = obj.localModels{i}.calcLocalModelOutput(obj.xRegressor);
end

% weight each output with the corresponding weight
output = normValidity * outputLM';


if ~obj.trainFlag 
    output = obj.reNormOutput(output);
end



end

