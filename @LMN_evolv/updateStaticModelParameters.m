function  obj = updateStaticModelParameters(obj,dynModel)
%UPDATESTATICMODELPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
for i = 1 : obj.getNumberOfLocalModels
   obj.localModels{i}.theta = dynModel.localModels{i}.calcStaticParameters(obj.localModels{i}.calcNumberOfLocalParameters,dynModel.dimIn);
end

end

