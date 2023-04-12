function obj = trainLocalModels(obj,input,output)
%TRAINLOCALMODELS Summary of this function goes here
%   Detailed explanation goes here

 % use inputTrain and outputTrain from obj when no specific input and
 % output is given
 if nargin<2
     input = obj.inputTrain;
     output = obj.outputTrain;
 end
 
 % Build weighting matrices for each local model (TEST: hier die
 % Regressoren übergeben)
 normValidity = obj.calcNormValidity(obj.zRegressor,output);
 
 % update weighting vector for first output values
 if isempty(obj.weighting)
     obj.weighting = ones(size(output));
 end
 obj.weighting(1:obj.getMaxDelay) = 0;
 
 
 for i = 1 : obj.getNumberOfLocalModels
    if obj.localModels{i}.fixedModel == false
        weighting = normValidity(:,i) .* obj.weighting;
        obj.localModels{i} = obj.localModels{i}.estimateLocalModel(input,output,obj.xRegressor,weighting);
    end
 end

end

