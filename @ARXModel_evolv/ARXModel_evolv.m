classdef ARXModel_evolv < dynModel
    %ARXMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        inputDelays;
        outputDelays;
        zInputDelays;
        zOutputDelays;
    end
    
    methods
        function obj = ARXModel_evolv(lmn,p)
            %ARXMODEL Construct an instance of this class
            %   Detailed explanation goes here
            obj.inputDelays = lmn.xDynInputDelay{p};
            obj.outputDelays = lmn.xDynOutputDelay{1};
            obj.zInputDelays = lmn.zDynInputDelay{p};
            obj.zOutputDelays = lmn.zDynOutputDelay{1};
            
            obj.form = 'ARX';
        end
        
        % number of parameter
        function n = getNumberOfParameters(obj)
           
           if isempty(obj.inputDelays)
            n = 0;
           else
            n = obj.inputDelays; % output is added seperatly (+ obj.outputDelays;)
           end
        end
        
        % regressor
        [regressorIn,regressorOut] = buildRegressor(obj,input,output);
        [regressorIn,regressorOut] = buildZRegressor(obj,input,output);
        

        % static Model
        [staticParameter, thetaPointerNew] = getStaticParameter(obj,thetaDyn,thetaPointer)
        
    end
end

