function [obj] = insertNewLocalModel(obj,center,variance,trainFlag,splitCounter,typeOfValidityFunction)
%INSERTNEWLOCALMODEL Inserts new local model 
%   local model is build coresponding to the defined structure
    
    % check dimensions if not done yet
    if ~obj.dimensionCheck
        obj = obj.checkDimension;
    end

    [~,~,nPosSplits] = obj.getPosSplits;
    if nargin == 1
        center = ones(nPosSplits,1)* 0.5;
        variance = ones(nPosSplits,1) * obj.initialVariance;
        splitCounter = ones(nPosSplits,1);
        trainFlag = false;
        typeOfValidityFunction = 'gausian';
    elseif nargin == 3
        trainFlag = obj.trainFlag;
        typeOfValidityFunction = 'gausian';
        splitCounter = 1;
    elseif nargin < 5
        splitCounter = ones(nPosSplits,1);
        typeOfValidityFunction = 'gausian';
    elseif nargin < 6
        typeOfValidityFunction = 'gausian';
    end
    
    % bring center and variance into right format if needed
    if size(variance,1) == 1
        variance = variance';
    end
    if size(center,1) == 1
        center = center';
    end
    
    
    % call check dimension function if not called yet
    if ~obj.dimensionCheck
        obj = obj.checkDimension();
        obj.dimensionCheck = true;
    end
    
    obj.localModels{obj.getNumberOfLocalModels + 1} = LM_evolv(obj,center,variance,splitCounter,typeOfValidityFunction);
    
    % if first model is inserted create Regression matrix and output vector
    % once
    if (obj.getNumberOfLocalModels == 1 || ~obj.firstModelFlag) && ~obj.staticModelFlag && obj.trainFlag 
        
        % set flag that first model were used to build regressors
        obj.firstModelFlag = true;
        
        % Filter data before Regressors are build
        [obj, xInputFiltered, zInputFiltered] = obj.filterDataForTraining;
        
        % Incorporate dead time
        
        
        % Build regressors
        obj.xRegressor = obj.localModels{1}.buildRegressor(xInputFiltered,obj.outputTrain);
        obj.zRegressor = obj.localModels{1}.buildZRegressor(zInputFiltered,obj.outputTrain,obj.plotFlag);
    end
        
    % give each local model the regressor matrices
%     obj.localModels{1:obj.getNumberOfLocalModels}.xRegressor = obj.xRegressor;
%     obj.localModels{1:obj.getNumberOfLocalModels}.zRegressor = obj.zRegressor;
    
    % set Training Flag to given value
    obj.localModels{obj.getNumberOfLocalModels}.trainFlag = trainFlag;
end 

