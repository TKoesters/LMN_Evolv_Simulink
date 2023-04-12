function [regressorIn,regressorOut] = buildRegressor(obj,input,output)
%BUILDREGRESSOR Summary of this function goes here
%   Detailed explanation goes here
    regressorOut = [];
    
    % get information
    N = length(input);
    
    % build input regressor of corresponding model order
    regressorIn = ones(N+1,obj.inputDelays) .* input(1); % fill with first input value
    
    for row = 1 : N
        for coll = 1 : obj.inputDelays
            if 1+row-coll>0
                regressorIn(row+1,coll) = input(1+row-coll);
            else
                regressorIn(row+1,coll) = input(1);
            end
        end
    end    
end

