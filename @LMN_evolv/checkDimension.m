function obj = checkDimension(obj)
%CHECKDIMENSION Summary of this function goes here
%   Detailed explanation goes here

    % find models that are not empty
    if length(obj.xDynInputDelay)==1 && isempty(obj.xDynInputDelay{1})
        for i = 1 : obj.dimIn
            obj.xDynInputDelay{i} = [];
        end
    end
    
    if length(obj.zDynInputDelay)==1 && isempty(obj.zDynInputDelay{1})
        for i = 1 : obj.dimIn
            obj.zDynInputDelay{i} = [];
        end
    end
    
    if length(obj.xDynOutputDelay)==1 && isempty(obj.xDynOutputDelay{1})
        obj.xDynOutputDelay{1} = [];
    end
    
    
    if length(obj.zDynOutputDelay)==1 && isempty(obj.zDynOutputDelay{1})
        obj.zDynOutputDelay{1} = [];
    end
    
    
    if length(obj.xStaticInputFunc)==1 && isempty(obj.xStaticInputFunc{1})
        for i = 1 : obj.dimIn
            obj.xStaticInputFunc{i} = [];
        end
    end
    
    if length(obj.zStaticInputFunc)==1 && isempty(obj.zStaticInputFunc{1})
        for i = 1 : obj.dimIn
            obj.zStaticInputFunc{i} = [];
        end
    end
    
    if isempty(obj.xDeadTimes) 
        for i = 1 : obj.dimIn
            obj.xDeadTimes{i} = 0;
        end
    end
    
    if isempty(obj.zDeadTimes)
        for i = 1 : obj.dimIn
            obj.zDeadTimes{i} = 0;
        end
    end
    
    if length(obj.zSpaceInputFilterPoles)==1 && isempty(obj.zSpaceInputFilterPoles{1})
        for i = 1 : obj.dimIn
            obj.zSpaceInputFilterPoles{i} = [];
        end
    end
    
    if length(obj.xSpaceInputFilterPoles)==1 && isempty(obj.xSpaceInputFilterPoles{1})
        for i = 1 : obj.dimIn
            obj.xSpaceInputFilterPoles{i} = [];
        end
    end
    
    if isempty(obj.inputRanges)
        obj.inputRanges = nan(obj.dimIn,2);
    else
        temp = obj.inputRanges;
        obj.inputRanges = nan(obj.dimIn,2);
        for i = 1 : length(temp(:,1))
            if ~all(temp(i,:) == [0,0])
                obj.inputRanges(i,:) = temp(i,:);
            end
        end
    end
    
    % check input info
    for i = 1 : obj.dimIn
        if isempty(obj.info)
            obj.info.inputDescription{i} = ['u_' num2str(i)];
        elseif length(obj.info.inputDescription) <i
            obj.info.inputDescription{i} = ['u_' num2str(i)];
        end
    end

    % create input ranges
    obj.indexInput = zeros(obj.dimIn,i);
    startIndex = 0;
    endIndex = 0;
    if obj.offset
        startIndex = 2;
        for i = 1 : obj.dimIn
            if isempty(obj.xDynInputDelay{i})
                % static input
                if ~isempty(obj.xStaticInputFunc{i})
                    endIndex = startIndex + length(obj.xStaticInputFunc{i});
                end
                obj.indexInput(i,1:2) = [startIndex, endIndex];
                startIndex = endIndex +1;
            else
                % dynamic input
                endIndex = startIndex + obj.xDynInputDelay{i}-1;
                obj.indexInput(i,1:2) = [startIndex, endIndex];
                startIndex = endIndex +1;
            end
        end
    else
        startIndex = 1;
        for i = 1 : obj.dimIn
            if isempty(obj.xDynInputDelay{i})
                % static input
                if ~isempty(obj.xStaticInputFunc{i})
                    endIndex = startIndex + length(obj.xStaticInputFunc{i});
                end
                obj.indexInput(i,1:2) = [startIndex, endIndex];
                startIndex = endIndex +1;
            else
                % dynamic input
                endIndex = startIndex + obj.xDynInputDelay{i}-1;
                obj.indexInput(i,1:2) = [startIndex, endIndex];
                startIndex = endIndex +1;
            end
        end
    end
    
    obj.dimensionCheck = true;
end