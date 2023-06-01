function [obj,xInputTt,zInputTt] = updateDeadtimeDatapuffer(obj,input)
%UPDATEDEADTIMEDATAPUFFER Updates DeadTime Datapuffer
%   Is used to update the deadtime datapuffer and to get the current input
%   sample corresponding to the desired deadtime
    
% Deadtimepuffer is a matrix as long as the longest possible deadtime
%
% for shorter deadtimes only the first x values are used

    xInputTt = input;
    zInputTt = input;
    
    
    for i = 1 : obj.dimIn
        if obj.xDeadTimes{i} ~= 0 
            xInputTt(i) = obj.xDeadTimeDataPuffer(i,obj.xDeadTimes{i});
            obj.xDeadTimeDataPuffer(i,:) = [input(i),obj.xDeadTimeDataPuffer(i,1:end-1)];
        end
        
        if obj.zDeadTimes{i} ~= 0
            zInputTt(i) = obj.zDeadTimeDataPuffer(i,obj.zDeadTimes{i});
            obj.zDeadTimeDataPuffer(i,:) = [input(i),obj.zDeadTimeDataPuffer(i,1:end-1)];
        end
    end
end

