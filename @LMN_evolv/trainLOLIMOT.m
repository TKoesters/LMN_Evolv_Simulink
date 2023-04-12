function obj = trainLOLIMOT(obj)
%TRAINLOLIMOT Summary of this function goes here
%   Detailed explanation goes here
    
    % set Training flag 
    obj.trainFlag = true;
    obj = obj.setLocalTrainFlag(true);
    
    % call check dimension function if not called yet
    if ~obj.dimensionCheck
        obj = obj.checkDimension();
        obj.dimensionCheck = true;
    end
    
    obj = obj.checkLinInputsSpace;
    
    % save data in given Range
    inputTrainRange = obj.inputTrain;
    outputTrainRange = obj.outputTrain;
    
    % norm dataset
    obj = obj.normTrainData;

    % LOLIMOT Algorithm 
    iteration = 1;

    % insert first local model
    [~,~,nPosSplits] = obj.getPosSplits;
    center = ones(nPosSplits,1) * 0.5;
    variance = ones(nPosSplits,1) * obj.initialVariance;
    obj = obj.insertNewLocalModel(center,variance,obj.trainFlag);
    obj = obj.trainLocalModels;
    
    % set worst local model to 1 
    worstLocalModel = 1;
    
    [terminationCriteria,obj.informationCriterion] = obj.checkTerminationCriteria;
    
    % set termination Criteria to flase for first iteration
    if obj.maxNumberOfLocalModels ~=1
        terminationCriteria = 0;
    end

    % write history
    obj.history.trainingError(iteration) = obj.calcTrainingError;
    obj.history.testError(iteration) = obj.calcTestError;
    obj.history.informationCriterion(iteration) = obj.informationCriterion;

    
    while ~terminationCriteria
        disp(['------------------------------- Interation: ' num2str(iteration) ' -------------------------------']);
        
        % find worst local model
        worstLocalModel = obj.findWorstLocalModel;
        indexWorstLocalModel = 1;

        % initialize training
        bestPerformance = obj.calcTrainingError;
        bestModel = obj;
        bestPerformanceIndex = 0;
        
        %get possible splits
        [splitDyn,splitStatic,nPosSplits] = obj.getPosSplits;
        
        %try each split
        while (bestPerformanceIndex==0) && (indexWorstLocalModel <= length(worstLocalModel))
            disp(['Check model ' num2str(worstLocalModel(indexWorstLocalModel))]);
            for i = 1 : nPosSplits
                tempLMN = obj.splitLocalModel(worstLocalModel(indexWorstLocalModel),i);
                tempLMN = tempLMN.trainLocalModels;
                modelPerformance = tempLMN.calcTrainingError;
                disp(['Check dimension ' num2str(i) ': error ' num2str(modelPerformance)]);
                if modelPerformance < bestPerformance
                    bestPerformance = modelPerformance;
                    bestPerformanceIndex = i;
                    bestModel = tempLMN; 
                end
            end
            indexWorstLocalModel = indexWorstLocalModel + 1;
        end
        
        if bestPerformanceIndex == 0
            % no improvement with any cut could be made
            terminationCriteria = true;
            disp('No improvement with further cuts possible: Stop Training');
        else

            % submit best new model to obj
            obj = bestModel;
            fprintf('Best improvment achieved with split in dimension %1i \n \n',bestPerformanceIndex);
            
            [terminationCriteria,obj.informationCriterion] = obj.checkTerminationCriteria;
            iteration = iteration + 1;

        end
        
        %% Write history 
        obj.history.testError(iteration) = obj.calcTestError;
        obj.history.informationCriterion(iteration) = obj.informationCriterion;
        obj.history.trainingError(iteration) = bestPerformance;

    end
    
    % put Train data back to inital range
    obj.inputTrain = inputTrainRange;
    obj.outputTrain = outputTrainRange;

    % reset Training flag
    obj = obj.terminateTraining;
end

