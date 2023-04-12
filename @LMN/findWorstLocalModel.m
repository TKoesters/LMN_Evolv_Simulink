function worstLocalModel = findWorstLocalModel(obj)
%FINWORSTLOCALMODEL Summary of this function goes here
%   Detailed explanation goes here

    % Build weighting matrices for each local model
    normValidity = obj.calcNormValidity(obj.zRegressor,obj.outputTrain);
    localError = zeros(obj.getNumberOfLocalModels,1);
    
    switch obj.methodWorstLocalModel
        case 'localSeperated'
            for i = 1 : obj.getNumberOfLocalModels
                weighting = diag(normValidity(:,i));
                localError(i) = obj.localModels{i}.calcLocalModelError(obj.inputTrain,obj.outputTrain,weighting);
            end

            % alt [maxError,maxErrorIndex] = max(localError);
            [maxError,maxErrorIndex] = sort(localError);
            worstLocalModelTemp = fliplr(maxErrorIndex);
            
            worstLocalModel = zeros(obj.getNumberOfLocalModels - obj.getNumberOfFixedLocalModels,1);
            index = 0;
            for i = 1 : obj.getNumberOfLocalModels
                if obj.localModels{i}.fixedModel == false
                    index = index +1; 
                    worstLocalModel(index) = worstLocalModelTemp(i);
                end
            end
            
            
        case 'globalWeighted'
            yHat = obj.calcModelOutputTrain;
            globalError = (yHat-obj.outputTrain).^2;
            weightedError = globalError' * (normValidity.*obj.weighting);
            [maxError,maxErrorIndex] = sort(weightedError);
            worstLocalModelTemp = fliplr(maxErrorIndex);
            
            % account for fixed lcoal models
            worstLocalModel = zeros(obj.getNumberOfLocalModels - obj.getNumberOfFixedLocalModels,1);
            index = 0;
            for i = 1 : obj.getNumberOfLocalModels
                if obj.localModels{worstLocalModelTemp(i)}.fixedModel == false
                    index = index +1; 
                    worstLocalModel(index) = worstLocalModelTemp(i);
                end
            end
    end
end

