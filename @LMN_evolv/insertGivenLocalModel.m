function obj = insertGivenLocalModel(obj,localModel)
%INSERTGIVENLOCALMODEL Summary of this function goes here
%   Detailed explanation goes here

% gaussian function 
switch localModel.validityFunction.getTypeOfValidityFunction
    case 'gausian'
        obj = obj.insertNewLocalModel(localModel.getCenter,localModel.getVariance,false,localModel.splitCounter,'gausian');
    case 'hardBound'
        obj = obj.insertNewLocalModel(localModel.validityFunction.getBound,localModel.validityFunction.getDirection,false,localModel.splitCounter,'hardBound');
end

end

