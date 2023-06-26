function staticModel = getStaticModel(obj)
%GETSTATICMODEL Summary of this function goes here
%   Detailed explanation goes here

% create instance of new LMN
staticModel = LMN_evolv;

% set static Model flag
staticModel.staticModelFlag = true;

% give properties of dynamic LMN to static LMN
staticModel.dimIn = obj.dimIn;

% add global Offset
staticModel.globalOffset = obj.globalOffset;
staticModel.globalOffsetFlag = obj.globalOffsetFlag;

% iterate through all inputs
for i = 1 : obj.dimIn
    
    % create static input property x Space
    if (~isempty(obj.xStaticInputFunc{i})) && (~isempty(obj.xDynInputDelay{i})) 
        staticModel.xStaticInputFunc{i} = {obj.xStaticInputFunc{i}{:},@(u)u};
    elseif ~isempty(obj.xDynInputDelay{i}) 
        staticModel.xStaticInputFunc{i} = {@(u)u};
    elseif ~isempty(obj.xStaticInputFunc{i})
        staticModel.xStaticInputFunc{i} = {obj.xStaticInputFunc{1,i}{:}};
    else 
        staticModel.xStaticInputFunc{i} = {};
    end
    
    % create static input property z Space
    if (~isempty(obj.zStaticInputFunc{i})) && (~isempty(obj.zDynInputDelay{i})) 
        staticModel.zStaticInputFunc{i} = {obj.zStaticInputFunc{i}{:},@(u)u};
    elseif ~isempty(obj.zDynInputDelay{i}) 
        staticModel.zStaticInputFunc{i} = {@(u)u};
    elseif ~isempty(obj.zStaticInputFunc{i})
        staticModel.zStaticInputFunc{i} = {obj.zStaticInputFunc{i}{:}};
    else
        staticModel.zStaticInputFunc{i} = {};
    end
        
end

% perform dimension check
staticModel = staticModel.checkDimension;

% add local models to static model
for i = 1 : obj.getNumberOfLocalModels
    staticModel = staticModel.insertGivenLocalModel(obj.localModels{i});
    staticModel.localModels{i}.theta = obj.localModels{i}.calcStaticParameters(staticModel.localModels{i}.calcNumberOfLocalParameters,obj.dimIn,obj.outputRange,obj.inputRanges);
end

% give other information to static model
staticModel.inputRanges = obj.inputRanges;
staticModel.outputRange = obj.outputRange;
staticModel.info = obj.info;
staticModel.smoothness = obj.smoothness;

% give output nonlinearity to static model
staticModel.outputNonlinearity = obj.outputNonlinearity;
staticModel.outputInversNonlinearity = obj.outputInversNonlinearity;

% check for linear input space
staticModel = staticModel.checkLinInputsSpace;

end

