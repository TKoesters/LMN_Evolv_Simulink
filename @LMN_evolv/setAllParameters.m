function obj = setAllParameters(obj,localLinParameters,localCenters,localVariance)
%GETALLPARAMETERS Summary of this function goes here
%   Detailed explanation goes here


%% create matrix with local lin parameters
% 
% M = [theta_LM1, theta_LM2, ... , theta_LMn];

% CODE GENERATION 
for i = 1 : obj.getNumberOfLocalModels
    obj.localModels{i}.theta = localLinParameters(:,i);
end

if nargin>2
    %% create matrix with local Centers AND Variances 
    % M = [mu_LM1, mu_LM2, ... , mu_LMn];
    % S = [sigma_LM1, sigma_LM2, ... , sigma_LMn]
    for i = 1 : obj.getNumberOfLocalModels
         obj.localModels{i}.validityFunction.center = localCenters(:,i);
    end

    for i = 1 : obj.getNumberOfLocalModels
        obj.localModels{i}.validityFunction.variance = localVariance(:,i);
    end
end

end

