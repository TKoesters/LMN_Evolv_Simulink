function [testError] = calcTestError(obj,errorMeasurement,weighting)
%CALCTRAININGERROR Summary of this function goes here
%   Detailed explanation goes here

    if isempty(obj.inputTest) || isempty(obj.outputTest)
%         warning('No test data were submitted');
        testError = NaN;
    else

        if nargin < 3
            weighting = ones(size(obj.outputTest));
        end
        if nargin < 2
            errorMeasurement = obj.errorMeasurement;
            weighting = ones(size(obj.outputTest));
        end

        yHatTest = obj.calcModelOutputTest;

        switch errorMeasurement
            case 'NRMSE'
                squaredError = sum((obj.outputTest-yHatTest).^2.*weighting);
                weightedMean = sum(obj.outputTest.*weighting) / sum(weighting);
                varMeasurement = sum((obj.outputTest - weightedMean).^2.*weighting);
                testError =  sqrt(squaredError/varMeasurement);
            case 'MSE'
                testError = 1/length(obj.outputTest) * sum((yHatTest-obj.outputTest).^2);
            case 'RMSE'
                testError =  sqrt(sum((yHatTest-obj.outputTest).^2) / length(obj.outputTest));
        end

    end

end

