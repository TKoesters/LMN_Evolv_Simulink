function ub = getHyperparameterUpperBound(obj)
%GETHYPERPARAMETERLOWERBOUND Summary of this function goes here
%   Detailed explanation goes here

ub = inf(length(obj.hyperparameter2Optimize),1);

for i = 1 : length(obj.hyperparameter2Optimize)
    switch obj.hyperparameter2Optimize{i}
        case 'alpha'
            ub(i) = 1;
        case 'lambda'
            ub(i) = 1000;
        case 'a'
            ub(i) = 1;        
        case 'a2'
            ub(i) = 1;
        otherwise 
            error('Invalid choise of hyperparameter to optimize');
    end
    
end

end

