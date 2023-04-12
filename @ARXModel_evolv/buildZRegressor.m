function [regressorIn,regressorOut] = buildZRegressor(obj,input,output)
%BUILDREGRESSOR Summary of this function goes here
%   Detailed explanation goes here

    % get information
    N = length(input(:,1));
    p = length(input(1,:));
    
    % build input regressor of corresponding model order
    regressorIn = ones(N+1,obj.zInputDelays).*input(1); % fill with first input
    regressorOut = ones(N+1,obj.zOutputDelays).*output(1); % fill with first output
    for row = 1 : N
        for collIn = 1 : obj.zInputDelays
            if 1+row-collIn>0
                regressorIn(row+1,collIn) = input(1+row-collIn);
            else
                regressorIn(row+1,collIn) = input(1);
            end
        end
        for collOut = 1:obj.zOutputDelays
            if 1+row-collOut>0
                regressorOut(row+1,collOut) = output(1+row-collOut);
            else
                regressorOut(row+1,collOut) = 0;
            end
        end
    end
end

