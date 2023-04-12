function [Tt] = investigateDeadTimeL1Reg(obj,lambda,numberLMs,rangeTt)

%INVESTIGATEDEADTIMEL1REG Summary of this function goes here
%   Detailed explanation goes here


if nargin == 2
    numberLMs = 1;
    rangeTt = repmat([0 150],obj.dimIn,1);
elseif nargin==3
    rangeTt = repmat([0 150],obj.dimIn,1);
end

%% Set up LMN and train


if all(cellfun(@isempty,obj.zStaticInputFunc)) && all(isempty(cell2mat(obj.zDynInputDelay))) 
    zStaticFlag = true;
else
    zStaticFlag = false;
end

for i = 1 : obj.dimIn
    obj.xDynInputDelay{i} = rangeTt(i,2) - rangeTt(i,1);
    

    if zStaticFlag && numberLMs == 1
       obj.zStaticInputFunc{i}={@(u)u};   
    elseif zStaticFlag
        obj.zDynInputDelay{i} = rangeTt(i,2) - rangeTt(i,1);
    end
        
end

obj.maxNumberOfLocalModels = numberLMs;

% train lmn with lolimot

obj.RegOptions.method = 'L1';
obj.RegOptions.lambda = lambda;

obj = obj.trainLOLIMOT;


%% L1-Reg (Lasso) Method 
obj.plotParameters;

obj.compareModel;



end

