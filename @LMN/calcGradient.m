function grad = calcGradient(obj,AP)
%CALCGRADIENT Summary of this function goes here
%   Detailed explanation goes here

% norm inputs 
normedAP = obj.normInputs(AP);

% calc norm validity
normValidity = obj.calcNormValidity(normedAP);

% iterate through all local models
grad= zeros(obj.dimIn,1);

for i = 1 : obj.getNumberOfLocalModels
    grad = grad + normValidity(i) .* obj.localModels{i}.calcLocalGradient;
end

end

