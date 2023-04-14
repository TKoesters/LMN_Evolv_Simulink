classdef staticModel_evolv
    %STATICMODELS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        xStaticInputFunc;
        zStaticInputFunc;
    end
    
    methods
        function obj = staticModel_evolv(lmn,p)
            %STATICMODELS Construct an instance of this class
            %   Detailed explanation goes here
            obj.xStaticInputFunc = lmn.xStaticInputFunc{p};
            obj.zStaticInputFunc = lmn.zStaticInputFunc{p};
        end
        
        regressor = buildRegressor(obj,input);
    
        [staticParameter,pointerIncrement] = getStaticParameter(obj,thetaDyn,thetaPointer);
        
    end
    
    
end

