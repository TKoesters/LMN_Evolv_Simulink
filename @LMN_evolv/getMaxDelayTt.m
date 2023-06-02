function [maxDelay,index] = getMaxDelayTt(obj)
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

% find max Tt
xMaxTt = getMaxDeadTime(obj.xDeadTimes);
zMaxTt = getMaxDeadTime(obj.zDeadTimes);

maxDelay = maxDelay + max(zMaxTt,xMaxTt);

%% cell2mat
%[maxDelay,index] = max([cell2mat(obj.xDynInputDelay),cell2mat(obj.xDynOutputDelay)]);

end

%% functions 
function out = getMaxDeadTime(in)
    out = 0;
    for i  = 1 : length(in)
        out = max(out,in{i});
    end
end