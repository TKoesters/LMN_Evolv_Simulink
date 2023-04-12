function regressor = buildRegressor(obj,input)
%BUILDREGRESSOR Summary of this function goes here
%   Detailed explanation goes here
    if isempty(obj.xStaticInputFunc)
        regressor = [];
    else
        nFunc = length(obj.xStaticInputFunc);
        
        if (nFunc==1 && obj.xStaticInputFunc{1}(100)==100) % 1 function and linear 
            regressor = input;
        else

            regressor = zeros(length(input(:,1)),nFunc);

            for i = 1 : nFunc
                %func = obj.xStaticInputFunc{i};
                %regressor(:,i) = func(input);
                regressor(:,i) = obj.xStaticInputFunc{i}(input);
            end
        end
    
        % add first value at the beginning 
        regressor = [regressor(1,:);regressor];
    end
    
end

