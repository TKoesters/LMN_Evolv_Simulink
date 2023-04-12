function nEff = getNumberOfLocalEffParameters(obj,input,output,xRegressor,weighting)
%GETNUMBEROFLOCALEFFPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

    % build weighting matrix
    %Q = weighting;
    
    % build regressor matrix
    %X = obj.buildRegressor(input,output);
    
    % build regularisation matrix
    %R = obj.buildRegularizationMatrix;

    % build Smoothing matrix S
    %S = weighting .* obj.xRegressor * obj.invMatrix;
    
    % calc nEff
    %nEff = trace(diag(weighting .* obj.xRegressor * obj.invMatrix));
    
    nEff = 0;
    if ~obj.fixedModel
        for i = 1 : length(weighting)
            nEff = nEff + weighting(i) * xRegressor(i,:) * obj.invMatrix(:,i);
        end
    end
end


