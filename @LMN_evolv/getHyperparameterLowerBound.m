function lb = getHyperparameterLowerBound(obj)
%GETHYPERPARAMETERLOWERBOUND Summary of this function goes here
%   Detailed explanation goes here

lb = inf(length(obj.hyperparameter2Optimize),1);

for i = 1 : length(obj.hyperparameter2Optimize)
    switch obj.hyperparameter2Optimize{i}
        case 'alpha'
            lb(i) = 0;
        case 'lambda'
            lb(i) = 0;
        case 'a'
            lb(i) = 0;
        case 'a2'
            lb(i) = 0;
        otherwise 
            error('Invalid choise of hyperparameter to optimize');
    end
    
end

end

