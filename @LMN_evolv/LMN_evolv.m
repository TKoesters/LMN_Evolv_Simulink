classdef LMN_evolv
    %LMN High level Claas to save a whole local model network
    %   % hallo % 
    %   LMN Claas consits of different local models (LM). The LMN class
    %   orgenizes the LMs to a local model network and supports functions 
    %   as training or updating of the local model network. Furthermore it
    %   can be used to evaluate the model for certain inputs.
    %
    %
    %  PROPERTIES:
    %
    %       localModels {N_LMs}  -  cell-array with stored LMs of the LMN
    %       
    %   Training
    %       inputTrain [N x p]   -  matrix with p input arrays each with N
    %                               values
    %       outputTrain [N x 1]  -  array with 1 output array with N values
    %   
    %   Test
    %       inputTest [N x p]    -  matrix with p input arrays each with N
    %                               values
    %       outputTest [N x 1]   -  array with 1 output array with N values
    % 
    %   Validation
    %       inputVal [N x p]     -  matrix with p input arrays each with N
    %                               values
    %       outputVal [N x 1]    -  array with 1 output array with N values
    % 
    %   Input and Output Dealys Dynamic
    %       xDynInputDelay {p*[]}   -
    %       xDynOutputDealy {1*[]}  -
    %       zDynInputDelay {p*[]}   -
    %       zDynOutputDelay {1*[]}  -
    %
    %   Input static func
    %       xStaticInputFunc {p*{}}  - 
    %       zStaticInputFunc {p*{}}  -
    %
    %   Regularization
    %       RegOptions.method  String      
    %       RegOptions.weighting true/false
    %       RegOptions.lambda {p} oder {1}
    %       RegOptions.alpha {[1,1]} oder {p*[1,1]}
    %
    %   Dead Times
    %       xDeadTimes {p}          -
    %       zDeadTimes {p}          -
    %
    %   Type of defuzzification
    %       aggregationMethod String -  Method how the local model are
    %                                   aggregated (e.g.
    %                                   'normalized','direct');
    %       
    %
    %  FUNCTIONS
    %
    %   Training 
    %       train(obj)  -  Trains LMN with corresponding algorithm
    %
    %   Evaluation
    %       calcModelOutput(obj,inputs)  -  Calculates Model output to
    %                                       coresponding input values
    %   
    %   Creation of Model
    %       insertNewLocalModel(obj)  -  Inserts new local model to the
    %                                       network
    %       deleteLocalModel(obj,numberOfLocalModel) 
    
    properties
        % general structure 
        localModels = {};
        
        % input dimension
        dimIn = 1;
       
        % training inputs and outputs
        inputTrain = [];
        outputTrain = [];
        
        % test inputs and outputs
        inputTest = [];
        outputTest = [];
        
        % test inputs and outputs
        inputValidation = [];
        outputValidation = [];
        
        % dynamic input delay
        xDynInputDelay = {[]};
        zDynInputDelay = {[]};
        
        % dynamic output delay
        xDynOutputDelay = {[]};
        zDynOutputDelay = {[]};
        
        % static input func
        xStaticInputFunc = {[]};
        zStaticInputFunc = {[]};
        
        % Input Filter
        zSpaceInputFilterPoles = {[]};
        xSpaceInputFilterPoles = {[]};
        xSpaceFilterPuffer = {[]};
        zSpaceFilterPuffer = {[]};
        
        % Regularisation
        RegOptions;
        RegularisationMatrix = [];
        
        % Dead Times
        xDeadTimes = {};
        zDeadTimes = {};
        
        % Data Ranges for Normalization 
        outputRange = [];
        inputRanges  = [];
        
        % Index Input
        indexInput = [];

        % offset 
        offset = true;
    
        % delay of static systems
        staticDelay = 0;
        
        % dimension check
        dimensionCheck = false;
        firstModelFlag = false;
        
        % type of validity function
        validityFunction = 'gausian';
        initialVariance = 0.4;
        smoothness = 1;
        
        % Termination Criterion
        terminationCriterion = 'AICc';
        errorMeasurement ='NRMSE';
        informationCriterion = inf;
        maxNumberOfLocalModels = inf;
        
        % Train Flag
        trainFlag = false;
        
        % Regressors for use in the local models
        xRegressor = [];
        zRegressor = [];
        weighting = [];
        
        % method to find worst local model
        methodWorstLocalModel = 'globalWeighted';
        
        % Adaption
        adaptionFlag = false;
        AdaptOptions;
        xDeadTimeDataPuffer = {[]};
        zDeadTimeDataPuffer = {[]};
        currentOutput = 0;
        globalError = 0;
        
        % get Static Model 
        staticModelFlag = false;

        % lin input space 
        xlinInputSpaceFlag = false;
        zlinInputSpaceFlag = false;
        xlinInputSpace = [];
        zlinInputSpace = [];
        
        % plotFlag
        plotFlag = false;
        
        % info 
        info;
        history;
        
        % output Nonlinearity
        outputNonlinearity = [];
        outputInversNonlinearity = [];
        
        % hyperparameter to optimize
        hyperparameter2Optimize = {};

        % simulation in parralel needed
        parallelSimulation = false;

        % global offset model
        globalOffsetFlag = false;
        globalOffset = 0;
        
    end
    
    methods
        % Constructor
        function obj = LMN_evolv%(dimIn,xDynInputDelay,xDynOutputDelay,zDynInputDelay,zDynOutputDelay,localModels,zSpaceInputFilterPoles,xSpaceInputFilterPoles,maxNumberOfLocalModels)
            %LMN Construct an instance of this class
            %   Detailed explanation goes here    
            
            % Options for Regularization
            obj.RegOptions.method = 'none';
            obj.RegOptions.weighting = 'none';
            obj.RegOptions.lambda = 0;
            obj.RegOptions.alpha = 1;
            obj.RegOptions.a = 0;
            
            % Options for Adaption
            obj.AdaptOptions.forgettingFactor = 1;
            obj.AdaptOptions.methodParameterUpdate = 'RLS';
            obj.AdaptOptions.methodEvolving = 'none';
            obj.AdaptOptions.methodUpdateLocalModels = 'all';
            obj.AdaptOptions.Sigma0 = 0;
            obj.AdaptOptions.compensateNeff = false;
            obj.AdaptOptions.ActivationThreshold = 0;
            obj.AdaptOptions.nBest = 0;
            obj.AdaptOptions.offsetAdaptionSpeed = 0;
            obj.AdaptOptions.errorFilter = 0; % pole at 0 --> no filter active
            obj.AdaptOptions.localORglobalError = 'global';
            obj.AdaptOptions.inputs4Regularization = [];
            obj.AdaptOptions.methodForgetting = 'error'; % error, fortesque
            obj.AdaptOptions.desiredTrace = 5;
            obj.AdaptOptions.dataCollection = false;
            obj.AdaptOptions.information2plot = {'Neff','regAdaption','forgetting','trace Reg'};

            % insert info obj
            obj.info.inputDescription = {};
            obj.info.outputDescription = {'y'};
            
            % insert history obj
            obj.history.trainingError = [];
            obj.history.testError = [];
            obj.history.informationCriterion = [];
            obj.history.adaptionStatus = [];

            % Filtering of inputs 
            obj.zSpaceInputFilterPoles = {[]};
            obj.xSpaceInputFilterPoles = {[]};
            obj.xSpaceFilterPuffer = {[]};
            obj.zSpaceFilterPuffer = {[]};
            
%             % max number of local models 
%             obj.maxNumberOfLocalModels = maxNumberOfLocalModels;
            
        end
        
       % Prototypes of functions
       
       function number = getNumberOfLocalModels(obj)
            number = length(obj.localModels);
       end
       
       function number = getNumberOfFixedLocalModels(obj)
           number = 0;
           for i = 1 : obj.getNumberOfLocalModels 
              if obj.localModels{i}.fixedModel
                 number = number +1;
              end
           end
       end
       
       % Training
       obj = train(obj)
       obj = trainLOLIMOT(obj);
       obj = trainGivenStructure(obj);
       obj = deleteTrainingAndStructure(obj);
       obj = setLocalTrainFlag(obj,flagValue)
       obj = switchTestTrainData(obj);
       obj = redefineLocalModels(obj)
       obj = trainHyperParameter(obj,hyperParametersInit)
       
       % Hyperparameter
       obj = setHyperparameters(obj,hyperparameter);
       ub = getHyperparameterUpperBound(obj);
       lb = getHyperparameterLowerBound(obj);
       
       % Evaluation
       output = calcModelOutput(obj,input,output);     
       output = simulateModelParallel(obj,input)
       
       normValidity = calcNormValidity(obj,input,output);
       normValidity = calcNormValidityFeedback(obj,input,output);
       outputTrain = calcModelOutputTrain(obj);
       outputTest = calcModelOutputTest(obj);
       trainingError = calcTrainingError(obj,errorMeasurement);
       testError = calcTestError(obj,errorMeasurement,weighting);
       Error = calcError2InputSignal(obj,input,output,errorMeasurement);
       staticError = calcStaticModelError(obj,staticModel,errorMeasurement,constraints);
       worstLocalModel = findWorstLocalModel(obj);
       numberOfEffParameters = getNumberOfEffParameters(obj);
       n = getNumberOfParameters(obj);
       maxDelay = getMaxDelay(obj);
       maxDelayTt = getMaxDelayTt(obj);
       compareModel(obj,trainOrTest);
       plotTrainData(obj);
       plotTestData(obj);
       [variances] = calcParameterVariances(obj);
       
       % Splitting
       obj = splitLocalModel(obj,numberOfLocalModel,dimension);
       [splitDyn,splitStatic,nPosSplits] = getPosSplits(obj);
       [check,informationCriterion] = checkTerminationCriteria(obj);
       
       % Creation
       obj = insertNewLocalModel(obj,center,variance,trainFlag,splitCounter,typeOfValidityFunction);
       obj = deleteLocalModel(obj,numberOfLocalModel) 

       % Visualization
       plotValidity(obj,dimensions,AP,LMs);
       plotParameters(obj);
       showCenterAndVariances(obj);
       plotPartition(obj,zDimToPlot,D3Flag);
       plotNormalizedValidity(obj,inputDimension,inputPoint);
       [Z,X,Y] = plotStaticModel(obj,inputs2Plot,AP,plotPartition);
       plotAllStaticModels(obj,AP);
       plotPartialDependency(obj,AP);
       plotTrainingStats(obj);
       drawModelBlockDiagram(obj);
       data = showAdaptionStatus(obj,information2plot);
       plotAdaptionStatusOverTime(obj,adaptionStatus);
       
       % normalization
       obj = normTrainData(obj);
       inputNormed = normInputs(obj,input);
       outputNormed = normOutput(obj,output);
       output = reNormOutput(obj,output);
       input = reNormInputs(obj,normedInput,dimensions2renorm);
       
       % filtering 
       obj = initializeFilter(obj);
       [obj, xInputFildered, zInputFiltered] = filterData(obj,xInput,zInput);
       [obj, xInputFildered, zInputFiltered] = filterDataForTraining(obj);
       
       % terminate Training, Adaption
       obj = terminateTraining(obj);
       obj = terminateAdaption(obj);
       
       % Adaption
       %obj = initializeLMNforAdaption(obj,numerDatapoints);
       [obj, priorOutput] = updateLMN(obj,input,output,updateFlagLM,updateFlagOffset)
       obj = evolveLMN(obj);
       obj = updateLocalModels(obj,globalError);
       [obj,xInputTt,zInputTt] = updateDeadtimeDatapuffer(obj,input);
       obj = updateRegressors(obj,input,output);
       obj = setLocalAdaptionFlag(obj,flagValue);
       obj = updateGlobalOffset(obj,predOutput);
       linModel = getCurrentLinModel(obj,method);
       [A,B,C,D,offset] = getCurrentLinModelStateSpace(obj,method);
       [ATt,BTt,CTt,DTt,offset] = getCurrentLinModelStateSpaceTt(obj,method,delay,dimIn);
       theta = getCurrentLinCoeffs(obj,method);
       [localLinParameters,localCenters,localVariance] = getAllParameters(obj);

       % get Static Model 
       staticModel = getStaticModel(obj);
       obj = updateStaticModelParameters(obj,dynModel);
       staticModel = insertGivenLocalModel(obj,localModel);
       [staticTheta,localCenters,localVariance] = getCurrentStaticParameters(obj,numberOfLocalModels,numberOfLocalStaticParameters)
       
       % Gradient calculation
       grad = calcGradient(obj,AP);
       
       % lin input space
       obj = checkLinInputsSpace(obj);
       
       % clear up lmn for memory efficieny
       obj = cleanModel(obj);
       
       % investigate Deadtime
       [resultsDeadTime,obj] = investigateDeadTime(obj,inputs2investigate,deadTimeRanges);
       [resultsDeadTime,obj] = investigateDeadTimeFixedStructure(obj,inputs2investigate,deadTimeRanges);
       investigateDeadTimeCrossCorrelation(obj,inputs2check,posNeg);
       [Tt, cntfailed] = investigateDeadTimeCUSUM(obj,numberLMs,rangeTt,impulseOrStep);
       [Tt] = investigateDeadTimeL1Reg(obj,lambda,numberLMs,rangeTt);
    end
end

