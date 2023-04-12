function  Error = calcError2InputSignal(obj,input,output,errorMeasurement)
%CALCERROR2INPUTSIGNAL Summary of this function goes here
%   Detailed explanation goes here
    
    % determine error Measurement
    if nargin < 4
        errorMeasurement = obj.errorMeasurement;
        weighting = ones(size(output));
        weighting(1:obj.getMaxDelay) = 0;
    end


    % calc y_hat
    yHat = obj.calcModelOutput(input,output);

    % cacl error Measurement
    switch errorMeasurement
        case 'NRMSE'
            squaredError = sum((output-yHat).^2.*weighting);
            weightedMean = sum(output.*weighting) / sum(weighting);
            varMeasurement = sum((output - weightedMean).^2.*weighting);
            Error =  sqrt(squaredError/varMeasurement);
        case 'MSE'
            Error = 1/length(output) * sum((yHat-output).^2);
        case 'RMSE'
            Error =  sqrt(sum((yHat-output).^2) / length(output));
    end




end

