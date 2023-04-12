function obj = normTrainData(obj)
%NORMTRAINDATA Summary of this function goes here
%   Detailed explanation goes here

% if output nonlinearity is present transform data
if ~isempty(obj.outputNonlinearity)
    obj.outputTrain = obj.outputNonlinearity(obj.outputTrain);
    %obj.outputTest = obj.outputNonlinearity(obj.outputTest);
end

% if ranges are predefined use them else take them from training data
if isempty(obj.outputRange) 
    obj.outputRange = [min(obj.outputTrain), max(obj.outputTrain)];
end

% iterate through each input seperatly
for i = 1 : obj.dimIn
    if any(isnan(obj.inputRanges(i,:)))
        obj.inputRanges(i,:) = [min(obj.inputTrain(:,i),[],1)', max(obj.inputTrain(:,i),[],1)'];
    end
end

% norm data from 0 to 1
obj.outputTrain = normData(obj.outputTrain,obj.outputRange);

% substract offset if needed
if obj.globalOffsetFlag
    obj.outputTrain = obj.outputTrain - obj.globalOffset;
end

for i = 1 : obj.dimIn
    obj.inputTrain(:,i) = normData(obj.inputTrain(:,i),obj.inputRanges(i,:));
end


end


function normedData = normData(u,range)
    normedData = (u-range(1))./abs(range(2)-range(1));
end