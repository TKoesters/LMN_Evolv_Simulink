function output = calcModelOutput(obj,input,outputIn)
%CALCMODELOUTPUT Summary of this function goes here
%   Detailed explanation goes here

% if training flag is there don't norm data (its already done by function)
% else norm data with given ranges
if ~obj.trainFlag 
    input = obj.normInputs(input);
    if nargin==3
        outputIn = obj.normOutput(outputIn);
    end
end

if nargin < 3
    outputIn = [];
end

% check if dynamic or static model is present
if obj.staticModelFlag 
      normValidity = obj.calcNormValidity(input); 
      outputLM = zeros(length(input(:,1)),obj.getNumberOfLocalModels);
      for i = 1 : obj.getNumberOfLocalModels
        outputLM(:,i) = obj.localModels{i}.calcLocalModelOutput(input,outputIn,obj.xlinInputSpaceFlag,obj.xlinInputSpace);
      end
      for i = 1 : length(normValidity(:,1))
        output(i) = normValidity(i,:) * outputLM(i,:)';
      end
else

    % filtering of input data
    if obj.trainFlag && ~obj.parallelSimulation
        zInputFiltered = obj.zRegressor;
        xInputFiltered = obj.xRegressor;
    else
        xInputFiltered = zeros(size(input));
        zInputFiltered = zeros(size(input));

        for i = 1 : length(input(:,1))
            [obj,xInputFiltered(i,:),zInputFiltered(i,:)] = obj.filterData(input(i,:));
        end
    end


   
    
    % decide wether parallel simulation is needed or not
    if obj.parallelSimulation
        output = obj.simulateModelParallel(xInputFiltered);

    else
        % get validity from all local models
        if nargin==3
            normValidity = obj.calcNormValidity(zInputFiltered,outputIn);
        else
            normValidity = obj.calcNormValidity(zInputFiltered);
        end

        % get output from all local models
        outputLM = zeros(length(input(:,1)),obj.getNumberOfLocalModels);
        output = zeros(length(input(:,1)),1);
        for i = 1 : obj.getNumberOfLocalModels
            outputLM(:,i) = obj.localModels{i}.calcLocalModelOutput(xInputFiltered,outputIn);
        end
    
        % weight each output with the corresponding weight
        for i = 1 : length(normValidity(:,1))
            output(i) = normValidity(i,:) * outputLM(i,:)';
        end
    end
end

if ~obj.trainFlag 
    output = obj.reNormOutput(output);
end

end

