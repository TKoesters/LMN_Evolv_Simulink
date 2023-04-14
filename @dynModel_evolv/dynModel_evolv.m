classdef dynModel_evolv
    %DYNMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        form;
    end
    
    methods
        function obj = dynModel_evolv(inputDelay,outputDelay)
            %DYNMODEL Construct an instance of this class
            %   Detailed explanation goes here

        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

