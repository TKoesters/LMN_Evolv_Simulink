function [regressorIn,regressorOut] = buildZRegressor(obj,input,output)
%BUILDREGRESSOR Summary of this function goes here
%   Detailed explanation goes here

    % get information
    N = length(input);
    
   % build input regressor of corresponding model order
    if ~(isempty(obj.zInputDelays) && isempty(obj.zOutputDelays)) % do this only if dyn z Regressor is required
    
        regressorIn = ones(N+1,obj.zInputDelays).*input(1); % fill with first input
        regressorOut = zeros(N+1,sum(obj.zOutputDelays));        % fill with zeros
        for row = 1 : N
            for collIn = 1 : sum(obj.zInputDelays)
                if 1+row-collIn>0
                    regressorIn(row+1,collIn) = input(1+row-collIn);
                else
                    regressorIn(row+1,collIn) = input(1);
                end
            end
            for collOut = 1: sum(obj.zOutputDelays)
                if 1+row-collOut>0
                    regressorOut(row+1,collOut) = output(1+row-collOut);
                else
                    regressorOut(row+1,collOut) = 0;
                end
            end
        end
    else
        regressorIn=[];
        regressorOut=[];
    end
end

