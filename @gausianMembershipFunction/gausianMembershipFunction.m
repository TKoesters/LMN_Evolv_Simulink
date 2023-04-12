classdef gausianMembershipFunction < validityFunction
    %GAUSIANMEMBERSHIPFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        center;
        variance; 
    end
    
    methods
        function obj = gausianMembershipFunction(lmn,center,variance)
            %GAUSIANMEMBERSHIPFUNCTION Construct an instance of this class
            %   Detailed explanation goes here

            obj@validityFunction(lmn);
            
            % define center of gausian Function
            obj.center = center;
            
            % define variance of gausian function
            obj.variance = variance;
            
        end
        
        validity = calcValidity(obj,input,smoothness);
        
        function typeOfValidityFunction = getTypeOfValidityFunction(obj)
            typeOfValidityFunction = 'gausian';
        end
    end
end

