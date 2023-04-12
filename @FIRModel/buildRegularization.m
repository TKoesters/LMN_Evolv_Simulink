function R = buildRegularization(obj,method,weightingMethod,a,alpha,inputNumber)
%BUILDREGULARIZATION Summary of this function goes here
%   Detailed explanation goes here

nParameter = obj.inputDelays;
a = a(inputNumber);
alpha = alpha(inputNumber);

switch method
    case 'none'
        F = zeros(nParameter);
    case 'RIDGE'
        F = eye(nParameter);
    case 'TC'
        F = (1*eye(nParameter)+diag(-1*ones(nParameter-1,1),1));
    case 'IIRP'
        Ffull = (-a*eye(nParameter)+diag(1*ones(nParameter-1,1),1));
        F = Ffull(1:end-1,:);
        F = [F; zeros(1,nParameter-1) -a];
    case 'FIRP'
        F = (-a*eye(nParameter)+diag(1*ones(nParameter-1,1),1));
        F = F(1:end-1,:);
    otherwise
        F = zeros(nParameter);
end

switch weightingMethod
    case 'exp'
        if strcmp(method,'FIRP')
            weighting = diag(alpha.^-(0:nParameter-2));
        else
            weighting = diag(alpha.^-(0:nParameter-1));
        end
    case 'none'
        weighting = 1;
    otherwise
        weighting = 1;
end

R = F'*(weighting'*weighting)*F;

end

