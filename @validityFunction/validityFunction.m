classdef validityFunction
    %VALIDITYFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        zDynInputDelay;
        zDynOutputDelay;
        zStaticInputFunc;
    end
    
    methods
        function obj = validityFunction(lmn)
            obj.zDynInputDelay = lmn.zDynInputDelay;
            obj.zDynOutputDelay = lmn.zDynOutputDelay;
            obj.zStaticInputFunc = lmn.zStaticInputFunc;
        end
        
        zRegressor = buildZRegressor(obj,input,output);
        numberParameter = getNumberOfParameters(obj);
        typeOfValidityFunction = getTypeOfValidityFunction(obj);
    end
end

