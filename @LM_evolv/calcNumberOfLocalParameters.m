function n = calcNumberOfLocalParameters(obj)
%CALCNUMBEROFLOCALPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    
    % as if flag for calculation was already set
    if obj.nParameterFlag
        n = obj.nParameter;
    else

        %check offset 
        if obj.offset
            nDyn = 1;
        else
            nDyn = 0;
        end

        %iterate through all dynamic models
        for i = 1 : length(obj.dynamicModels)
            if ~isempty(obj.dynamicModels{i})
               nDyn = nDyn + obj.dynamicModels{i}.getNumberOfParameters;
            end
        end

        % add output delays
        if ~isempty(obj.xDynOutputDelay{1})
            nDyn = nDyn + obj.xDynOutputDelay{1};
        end
        
        %iterate through all static models
        nStatic = 0;
        for i = 1 : length(obj.staticModels)
            if ~isempty(obj.staticModels{i})
                nStatic = nStatic + obj.staticModels{i}.getNumberOfParameters;
            end
        end

        % sum up static and dynamic parameter number
        n = nDyn + nStatic;
%         obj.nParameterFlag = true;
%         obj.nParameter = n;
    end
    
end

