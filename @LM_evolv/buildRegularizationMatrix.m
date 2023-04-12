function R = buildRegularizationMatrix(obj)
%BUILDREGULARIZATIONMATRIX Summary of this function goes here
%   Detailed explanation goes here

    % catch no Regularization
    if strcmp(obj.RegOptions.method,'none')
        R = zeros(obj.calcNumberOfLocalParameters);
    else
        
        % lambda handling
        if length(obj.RegOptions.lambda) == 1
            lambda = obj.RegOptions.lambda * ones(length(obj.dynamicModels)+1,1);
        else
            lambda = obj.RegOptions.lambda;
        end
        
        % alpha Handling 
        if length(obj.RegOptions.alpha) == 1
             obj.RegOptions.alpha = obj.RegOptions.alpha * ones(length(obj.dynamicModels)+1,1);
        end
        
        % a handling 
        if length(obj.RegOptions.a) == 1
            obj.RegOptions.a = obj.RegOptions.a * ones(length(obj.dynamicModels)+1,1);
        end
        
        
        
        % with Regularization 
        R = [];

        % iterate through all dynamic models
        for i = 1 : length(obj.dynamicModels)
            if ~isempty(obj.dynamicModels{i})
                R = blkdiag(R,obj.dynamicModels{i}.buildRegularization(obj.RegOptions.method,obj.RegOptions.weighting,obj.RegOptions.a,obj.RegOptions.alpha,i) * lambda(i));
            end
        end

        % iterate through all static models
        for i = 1 : length(obj.staticModels)
            if ~isempty(obj.staticModels{i}.xStaticInputFunc)
                R = blkdiag(R,obj.staticModels{i}.buildRegularization(obj.RegOptions.method) * lambda(end));
            end
        end

        % add offset when needed
        if obj.offset
            if strcmp(obj.RegOptions.method,'RIDGE')
                R = blkdiag(1 * lambda(end), R);
            else
                R = blkdiag(0, R);
            end
        end
    end
end

