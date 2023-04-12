function maxTt = calcMaxDeadTime(obj)
%CALCMAXDEADTIME Summary of this function goes here
%   Detailed explanation goes here

    maxTt = max(cell2mat(obj.xDeadTimes));

end

