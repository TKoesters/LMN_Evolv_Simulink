function [obj,xInputTt,zInputTt] = updateDeadtimeDatapuffer(obj,input)
%UPDATEDEADTIMEDATAPUFFER Updates DeadTime Datapuffer
%   Is used to update the deadtime datapuffer and to get the current input
%   sample corresponding to the desired deadtime
    
    xInputTt = input;
    zInputTt = input;
    
    
    for i = 1 : obj.dimIn
        if obj.xDeadTimes{i} ~= 0 
            xInputTt(i) = obj.xDeadTimeDataPuffer{1,i}(end);
            obj.xDeadTimeDataPuffer{i} = [input(i), obj.xDeadTimeDataPuffer{1,i}(1:end-1)];
        end
        
        if obj.zDeadTimes{i} ~= 0
            zInputTt(i) = obj.zDeadTimeDataPuffer{1,i}(end);
            obj.zDeadTimeDataPuffer{i} = [input(i), obj.zDeadTimeDataPuffer{1,i}(1:end-1)];
        end
    end
end

