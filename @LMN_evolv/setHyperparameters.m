function obj = setHyperparameters(obj,hyperparameters)
%SETHYPERPARAMETERS Summary of this function goes here
%   Detailed explanation goes here


for i = 1 : length(obj.hyperparameter2Optimize)
    switch obj.hyperparameter2Optimize{i}
        case 'alpha'
            obj.RegOptions.alpha = hyperparameters(i);
        case 'lambda'
            obj.RegOptions.lambda = hyperparameters(i);
        case 'a'
            obj.RegOptions.a = hyperparameters(i);
        case 'a2'
            obj.RegOptions.a = [obj.RegOptions.a, hyperparameters(i)];
        otherwise 
            error('Invalid choise of hyperparameter to optimize');
    end
    
end
end

