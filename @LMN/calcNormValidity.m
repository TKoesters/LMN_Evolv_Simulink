function  normValidity = calcNormValidity(obj,input,output)
%CALCNORMVALIDITY Summary of this function goes here
%   Detailed explanation goes here
if nargin == 2
    output = zeros(size(input(:,1)));
end

    
% get validity from all local models and output
validity = zeros(length(input(:,1)),obj.getNumberOfLocalModels);
for i = 1 : obj.getNumberOfLocalModels
    if obj.staticModelFlag
        validity(:,i) = obj.localModels{i}.calcValidity(input,output,obj.plotFlag,obj.smoothness,obj.zlinInputSpaceFlag,obj.zlinInputSpace);
    elseif obj.parallelSimulation
        validity(:,i) = obj.localModels{i}.calcValidityWithRegressorDirect(input,obj.smoothness);
    else
        validity(:,i) = obj.localModels{i}.calcValidity(input,output,obj.plotFlag,obj.smoothness);
    end
end


% normalize each validity
sumValidity = sum(validity,2);

% does not work for code generation: normValidity = validity./sumValidity;
normValidity = zeros(size(validity));
for i = 1 : length(validity(:,1))
   if sumValidity(i) == 0
       normValidity(i,:) = 1/obj.getNumberOfLocalModels;
   else
       normValidity(i,:) = validity(i,:)/sumValidity(i);
   end
end

end

