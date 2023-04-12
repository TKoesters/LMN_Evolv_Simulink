function [obj] = estimateLocalModel(obj,input,output,xRegressor,weighting)
%ESTIMATELOCALMODEL Summary of this function goes here
%   Detailed explanation goes here
    
    % catch when no weighting was submitted
    if nargin < 4
        weighting = eye(length(output));
    end

    % get regressor for current input data
    tic;
    
    % OLD with calculation of regressor each time :
    % X = obj.buildRegressor(input,output);
    
    % OLD use regressor of local model
    % X = obj.xRegressor;
    
    % NEW
    X = xRegressor;
    
%     if isempty(X)
%         X = obj.buildRegressor(input,output);
%     end
    
    obj.RegressorBuildTime = toc;
    
    % cut y to get proper system
    y = output;
    
    % estimate parameters with least squares
    switch obj.RegOptions.method
        case 'none'
            tic;
            obj.invMatrix = (X'*(weighting.*X))\(weighting.*X)';
            obj.theta = obj.invMatrix * y;    
            obj.trainTime = toc;
        case {'FIRP','IIRP','RIDGE','TC'}
  
            R = obj.buildRegularizationMatrix;
            tic;

            % normalization of regularization strength
            normFaktor = sum(weighting) / obj.calcNumberOfLocalParameters;

            obj.invMatrix = (X'*(weighting.*X)+normFaktor * R)\(weighting.*X)';
            obj.theta = obj.invMatrix * y;    
            obj.trainTime = toc;
            
        case {'L1'}
            
            modelError = @(theta) sum((X * theta - y).^2) + obj.RegOptions.lambda * sum(abs(theta));
            
            obj.theta = fminunc(modelError,zeros(length(X(1,:)),1));
            
        otherwise
            
    end
    
    
    % set number of local models
    obj = obj.setNumberOfLocalParameters;
end

