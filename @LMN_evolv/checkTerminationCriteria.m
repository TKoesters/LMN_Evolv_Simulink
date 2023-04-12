function [check,informationCriterion] = checkTerminationCriteria(obj)
%CHECKTERMINATIONCRITERIA Summary of this function goes here
%   Detailed explanation goes here
    informationCriterion = obj.informationCriterion;
    check = false;
    if obj.getNumberOfLocalModels > 0
     

        % decide which criteria is used
        switch obj.terminationCriterion
            case 'AIC'
                numberParameters = obj.getNumberOfEffParameters;
                numberData =  length(obj.outputTrain);
                
                %calculate Akaike's correcteed information criterion
                AIC =numberData * log(obj.calcTrainingError,'MSE') + 2 * numberParameters;
                if AIC<obj.informationCriterion
                    informationCriterion = AIC;
                    check = false;
                else
                    check = true;
                    disp('Termination of LOLIMOT due to no improvement in AIC value');
                end
                
            case 'AICc'
                numberParameters = obj.getNumberOfEffParameters;
                numberData =  length(obj.outputTrain);
                
                AICc =numberData * log(obj.calcTrainingError('MSE')) + 2 * numberParameters + ...
                    (2 * numberParameters * (numberParameters + 1)) / ...
                    (numberData - numberParameters - 1);
                if AICc<obj.informationCriterion
                    check = false;
                    informationCriterion = AICc;
                else
                    check = true;
                    disp('Termination of LOLIMOT due to no improvement in AICc value');
                end
                
            case 'none'
                % do nothing;
                
            otherwise
                error('ERROR: no valid termination criterion was chosen');
        end


        if obj.getNumberOfLocalModels >=  obj.maxNumberOfLocalModels
            check = true;
            disp('Termination of LOLIMOT due to maximum number of local LMs reached');
        end
    end
end

