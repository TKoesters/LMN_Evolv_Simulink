function [maxDelay,index] = getMaxDelay(obj)
%GETMAXDELAY Summary of this function goes here
%   Detailed explanation goes here

[maxDelay,index] = max([cell2mat(obj.xDynInputDelay),cell2mat(obj.xDynOutputDelay)]);

end