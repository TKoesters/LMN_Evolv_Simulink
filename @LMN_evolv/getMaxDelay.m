function [maxDelay,index] = getMaxDelay(obj)
%GETMAXDELAY Summary of this function goes here
%   Detailed explanation goes here

%% code generation
maxDelay = 0;
index = 1;
for i = 1 : obj.dimIn
    if obj.xDynInputDelay{i}>maxDelay
        index = i;
        maxDelay = obj.xDynInputDelay{i};
    end
end

if ~isempty(obj.xDynOutputDelay)
    if obj.xDynOutputDelay{1} > maxDelay
        index = i + 1;
        maxDelay = obj.xDynOutputDelay{1};
    end
end

%% cell2mat
%[maxDelay,index] = max([cell2mat(obj.xDynInputDelay),cell2mat(obj.xDynOutputDelay)]);

end