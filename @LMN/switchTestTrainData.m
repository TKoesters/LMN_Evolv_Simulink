function obj = switchTestTrainData(obj)
%SWITCHTESTTRAINDATA Summary of this function goes here
%   Detailed explanation goes here

inputTrain = obj.inputTrain;
outputTrain = obj.outputTrain;

if ~isempty(obj.inputTest) && ~isempty(obj.outputTest)
    obj.inputTrain = obj.inputTest;
    obj.outputTrain = obj.outputTest;
    obj.inputTest = inputTrain;
    obj.outputTest = outputTrain;
end

end

