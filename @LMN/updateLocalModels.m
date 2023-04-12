function obj = updateLocalModels(obj,globalError)
%UPDATELOCALMODELS Summary of this function goes here
%   Detailed explanation goes here
    
    models2updateNoForgetting = [];

    % calc normValidity
    normValidity  = obj.calcNormValidity(obj.zRegressor);

    % find local models that should be updated
    switch obj.AdaptOptions.methodUpdateLocalModels
        
        case 'all'
            models2update = 1 : obj.getNumberOfLocalModels;
            
        case 'all_noForgetting'
            [maxValue, maxIndex] = max(normValidity);
            models2update = maxIndex;
            models2updateNoForgetting = [1 : maxIndex-1, maxIndex+1:obj.getNumberOfLocalModels];
         
        case 'best'
            [maxValue, maxIndex] = max(normValidity);
            models2update = maxIndex;
            
        case 'nBest'
            [maxValue, maxIndex] = sort(normValidity,'descend');
            models2update = maxIndex(1:obj.AdaptOptions.nBest);
            
        case 'ActivationThreshold'
            all = 1 : obj.getNumberOfLocalModels;
            models2update = all(normValidity>obj.AdaptOptions.ActivationThreshold);
            
        otherwise
            error('No valid method for updating local models were chosen');
    
    end
    
    
    % update all local models chosen by the method
    
    for i = models2update
        obj.localModels{i} = obj.localModels{i}.updateLocalModel(obj.xRegressor, obj.currentOutput ,normValidity(i),obj.AdaptOptions,obj.RegularisationMatrix,obj.dimIn,obj.indexInput,globalError);
    end
    
    for i = models2updateNoForgetting
        AdaptOptions = obj.AdaptOptions;
        AdaptOptions.forgettingFactor = 1;
        obj.localModels{i} = obj.localModels{i}.updateLocalModel(obj.xRegressor, obj.currentOutput ,normValidity(i),AdaptOptions,obj.RegularisationMatrix,obj.dimIn,obj.indexInput,globalError);
    end
    
%     assignin('base','regAdaption1',obj.localModels{1}.RegAdaption);
%      assignin('base','regAdaption2',obj.localModels{2}.RegAdaption);
%     assignin('base','regAdaption3',obj.localModels{3}.RegAdaption);
%     assignin('base','regAdaption4',obj.localModels{4}.RegAdaption);
%     assignin('base','regAdaption5',obj.localModels{5}.RegAdaption);
%     assignin('base','regAdaption6',obj.localModels{6}.RegAdaption);


end

