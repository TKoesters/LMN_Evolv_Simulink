function trainError = calcLocalModelError(obj,input,output,weighting)
%CALCLOCALTRAININGERROR Summary of this function goes here
%   Detailed explanation goes here

    if nargin<4
        weighting = eye(length(output));
    end
    
    % calculate model output 
    yHat = obj.calcLocalModelOutput(input);
    
    % calculate weigthed error
    % OLD very slow:
    % error = (yHat - output)' * weighting * (yHat - output);
    error = sum((yHat - output).^2 .* diag(weighting)); 
    mean_y = mean(output);
    Sum_mean =(output-mean_y)' * (output-mean_y);
    
    trainError = sqrt(error/Sum_mean);
end

