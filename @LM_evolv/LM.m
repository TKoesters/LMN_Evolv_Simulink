classdef LM
    %LM Local Model Class
    %
    %  Class that defines how the local models look like. It consits of
    %  dynamic parts and static parts for each input dimension. 
    %
    %
    % PROPERTIES
    %
    %       dynamicModels {p*[n]}
    %       staticModels {p*String}
    
    properties
        
        dynamicModels = {};
        
        staticModels = {};
               
        offset = true;
       
        validityFunction;
        
        xDynInputDelay;
        xDynOutputDelay;
        xStaticInputFunc;
        
        zDynOutputDelay;
        zDynInputDelay;
        zStaticInputFunc;
        
        staticDelay;
        
        % Parameters
        theta;
        
        trainTime;
        RegressorBuildTime;
        
        splitCounter;
        
        RegOptions;
        
        % Dead Times
        xDeadTimes = {};
        zDeadTimes = {};
        
        % Regressoren
        xRegressor = [];
        zRegressor = [];
        
        % Training and Smoothing matrix 
        invMatrix = [];
        
        % Training Flag
        trainFlag = false;
        adaptionFlag = false;
        
        % nParameter
        nParameterFlag = false;
        nParameter = 0;
        
        % Adaption
        P_k = [];
        gamma_k = [];
        Z_k = [];
        M_k = [];
        forgetting = 1;
        N_eff = 0; % number of effective Data Points (Illg, Koesters, 2022)
        conditionMK = [];
        conditionMK_Reg = [];
        sigma_k = 0;
        error = 0;

        % information criteria
        detMK_inv;
        detMKReg_inv;
        diagP;
        diagPReg;
        traceMk;
        traceMkReg = 0;
        xTXXx;
        xTXXxReg;
        u_regler;
        
        % adaption of regularization
        valueDiff = 0;
        valueInfo = 0;
        RegAdaption = 1;
        Regler;

        % fixed local model
        fixedModel = false;
        
        
    end
    
    methods
        function obj = LM(lmn,center,variance,splitCounter,typeOfValidityFunction)
            %LM Construct an instance of this class
            %   Detailed explanation goes here
            
            [~,~,splitDimensions] = lmn.getPosSplits;
            if nargin<4
                splitCounter = ones(splitDimensions,1);
            end
            
            obj.splitCounter = splitCounter;
            
            
            % create local model regarding the chosen options in LMN
            for i = 1 : lmn.dimIn
               
               % dynamic local linear Models
               % decide between FIR and ARX
               if isempty(lmn.xDynOutputDelay{1}) && isempty(lmn.xDynInputDelay{i})
                   obj.dynamicModels{i} = [];
               elseif isempty(lmn.xDynOutputDelay{1})
                   obj.dynamicModels{i} = FIRModel(lmn,i);
               else
                   obj.dynamicModels{i} = ARXModel(lmn,i);
               end
               
               % static
               obj.staticModels{i} = staticModel(lmn,i);
              
               
            end
            obj.offset = lmn.offset;
            obj.staticDelay = lmn.staticDelay;
            
            obj.xDynInputDelay = lmn.xDynInputDelay;
            obj.xDynOutputDelay = lmn.xDynOutputDelay;
            obj.xStaticInputFunc = lmn.xStaticInputFunc;
            obj.zDynOutputDelay = lmn.zDynOutputDelay;
            obj.zDynInputDelay = lmn.zDynInputDelay;
            obj.zStaticInputFunc = lmn.zStaticInputFunc;
            obj.RegOptions = lmn.RegOptions;
            obj.xDeadTimes = lmn.xDeadTimes;
            obj.zDeadTimes = lmn.zDeadTimes;
            obj.Regler.P = 0;
            obj.Regler.I = 0;
            % create validity function regarding the chosen options in LMN
            switch typeOfValidityFunction
                case 'gausian'
                    obj.validityFunction = gausianMembershipFunction(lmn,center,variance);
                case 'hardBound'
                    obj.validityFunction = hardBoundMembershipFunction(lmn,center,variance);
                otherwise
                    error('ERROR: no valid type of validity function was given');
            end
        end
        
        % build regressor
        regressor = buildRegressor(obj,input,output);
        
        % estimate local Model
        obj = estimateLocalModel(obj,input,output,xRegressor,weighting);

        % calc validity
        validity = calcValidity(obj,input,output,plotFlag,smoothness,staticLinFlag,staticInputs);
        validity = calcValidityWithRegressorDirect(obj,zRegressor,smoothness);

        % calc Model output and error 
        trainError = calcLocalModelError(obj,input,output,weighting);
        yHat = calcLocalModelOutput(obj,input,output,staticFlag,staticInputSpace);
        gain = calcLocalModelGain(obj);

        % get variance and center
        function variance = getVariance(obj)
            variance = obj.validityFunction.variance;
        end
        
        function center = getCenter(obj)
            center = obj.validityFunction.center;
        end
        
        % nEff
        nEff = getNumberOfLocalEffParameters(obj,input,output,xRegressor,weighting);
        n = calcNumberOfLocalParameters(obj);
        obj = setNumberOfLocalParameters(obj);
        
        % Regularization
        R = buildRegularizationMatrix(obj);
        lambda = getLambda(obj);
        obj = updateRegInformation(obj,RegOptions);
        
        % plotting 
        plotParameter(obj,option,axesHandle);
        plotValidity(obj,inputDimension,AP);
        
        % Adaption
        obj  = updateLocalModel(obj,input,output,normValidity,method,RegularisationMatrix,dimIn,inputIndex,globalError);
        
        % Static Model
        thetaStatic = calcStaticParameters(obj,numberOfParameters,dimIn,outputRange,inputRanges);
        
        % Gradient 
        gradLocal = calcLocalGradient(obj);
        
        function obj = setFixedFlag(obj)
            obj.fixedModel = true;
        end
        
        % Parameter Variance
        variance = calcLocalParameterVariance(obj,xRegressor,weighting);
    end
end

