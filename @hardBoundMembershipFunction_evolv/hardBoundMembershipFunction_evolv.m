classdef hardBoundMembershipFunction_evolv < validityFunction
    %GAUSIANMEMBERSHIPFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        center;
        variance; 
        bound;
        direction;

    end
    
    methods
        function obj = hardBoundMembershipFunction_evolv(lmn,bound,direction)
            %GAUSIANMEMBERSHIPFUNCTION Construct an instance of this class
            %   Detailed explanation goes here

            obj@validityFunction(lmn);
            
            % define center of gausian Function
            obj.center = bound;
            
            % define variance of gausian function
            obj.variance = direction;
            
            % define bound of hard bound function
            obj.bound = bound;
            
            % define direction 
            obj.direction = direction;
        end
        
        validity = calcValidity(obj,input,smoothness);
        
        function typeOfValidityFunction = getTypeOfValidityFunction(obj)
            typeOfValidityFunction = 'hardBound';
        end
        
        function bound = getBound(obj)
            bound = obj.bound;
        end
        
        function direction = getDirection(obj)
            direction = obj.direction;
        end
    end
end

