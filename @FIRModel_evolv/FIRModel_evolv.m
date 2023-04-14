classdef FIRModel_evolv < dynModel_evolv
    %FIRMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % Parameters
        inputDelays;
        zInputDelays;
        zOutputDelays;
        
        % Regularization
        R;
    end
    
    methods
        function obj = FIRModel_evolv(lmn,p)
            %FIRMODEL Construct an instance of this class
            %   Detailed explanation goes here
            obj.inputDelays = lmn.xDynInputDelay{p};
            obj.zInputDelays = lmn.zDynInputDelay{p};
            obj.zOutputDelays = lmn.zDynOutputDelay{1};
            obj.form = 'FIR';
        end
        
       % number of parameter
       function n = getNumberOfParameters(obj)
           n = obj.inputDelays;
       end
        
       % build Regressor
       [regressorIn, regressorOut] = buildRegressor(obj,input,output);
       [regressorIn, regressorOut] = buildZRegressor(obj,input,output);

       
       % update information on Regularistaion
       obj = updateRegInformation(obj,RegOptions,p);
       
       % static Model
       [staticParameter, thetaPointerNew]= getStaticParameter(obj,thetaDyn,thetaPointer);
       
       % regularisation
       R = buildRegularization(obj,method,weightingMethod,a,alpha,inputNumber)
    end
end

