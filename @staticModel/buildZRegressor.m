function regressor = buildZRegressor(obj,input)
%BUILDREGRESSOR Summary of this function goes here
%   Detailed explanation goes here

    if isempty(obj.zStaticInputFunc)
                regressor = [];
    else
        nFunc = length(obj.zStaticInputFunc);
        
        if (nFunc==1 && obj.zStaticInputFunc{1}(100)==100) % 1 function and linear 
            regressor = input;
        else
            regressor = zeros(length(input(:,1)),nFunc);

            for i = 1 : nFunc
                %func = obj.zStaticInputFunc{i};
                %regressor(:,i) = func(input);
                regressor(:,i) = obj.zStaticInputFunc{i}(input);
            end

            % add first value at the beginning 
        end
        
        regressor = [regressor(1,:);regressor];
    end
end

