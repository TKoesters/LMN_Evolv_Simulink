function [trainingError] = calcTrainingError(obj,errorMeasurement)
%CALCTRAININGERROR Summary of this function goes here
%   Detailed explanation goes here
    
    if nargin == 1
        errorMeasurement = obj.errorMeasurement;
    end
    
    yHatTrain = obj.calcModelOutputTrain;
    
    switch errorMeasurement
        case 'NRMSE'
            error = obj.outputTrain-yHatTrain;
            Sum_error = obj.weighting' * error.^2;
            mean_y = mean(obj.outputTrain);
            Sum_mean =(obj.outputTrain-mean_y)' * (obj.outputTrain-mean_y);
            trainingError = sqrt(Sum_error/Sum_mean);
        case 'MSE'
            trainingError = 1/length(obj.outputTrain) * sum(obj.weighting.*(yHatTrain-obj.outputTrain).^2);
        case 'RMSE'
            if obj.trainFlag
                trainingError = sqrt(sum(obj.weighting.*(obj.reNormOutput(yHatTrain)-obj.reNormOutput(obj.outputTrain)).^2) / length(obj.outputTrain));
            else
                trainingError =  sqrt(sum(obj.weighting.*(yHatTrain-obj.outputTrain).^2) / length(obj.outputTrain));
            end
    end
    
    

end

