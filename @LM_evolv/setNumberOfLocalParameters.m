function obj = setNumberOfLocalParameters(obj)
%SETNUMBEROFLOCALPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

    %check offset 
    if obj.offset
        nDyn = 1;
    else
        nDyn = 0;
    end

%     %iterate through all dynamic models
%     for i = 1 : length(obj.dynamicModels)
%         if ~isempty(obj.dynamicModels{i})
%            nDyn = nDyn + obj.dynamicModels{i}.getNumberOfParameters;
%         end
%     end
% 
%     % add output delay
%     
% 
%     %iterate through all static models
%     nStatic = 0;
%     for i = 1 : length(obj.staticModels)
%         if ~isempty(obj.staticModels{i})
%             nStatic = nStatic + obj.staticModels{i}.getNumberOfParameters;
%         end
%     end
% 
%     % sum up static and dynamic parameter number
    n = obj.calcNumberOfLocalParameters;
    obj.nParameterFlag = true;
    obj.nParameter = n;
    
end

