function plotNormalizedValidity(obj,inputDimension,inputPoint)
%PLOTACTIVATION Summary of this function goes here
%   Detailed explanation goes here
    
    % check dimension if not done yet
    if ~obj.dimensionCheck
        obj = obj.checkDimension;
    end
    
    % set Plot Flag
    obj.plotFlag = true;
    plotInputFlag = false;
    
    switch nargin
        case 1
            if length(obj.localModels{1}.validityFunction.center) > 2
                warning('WARNING: no input dimension were submitted. 1 and 2 are automatically chosen.');
                inputDimension = [1;2];
            elseif  length(obj.localModels{1}.validityFunction.center) == 1
                inputDimension = [1];
            else
                inputDimension = [1;2];
            end

        case 2
            if length(inputDimension) > length(obj.localModels{1}.validityFunction.center)
                warning(['WARNING: more dimensions to plot than input dimensions were submitted.' ...
                    'only the first ' num2str(length(obj.validityFunction.center)) ' dimensions are used']);
                inputDimension = inputDimension(1:length(obj.validityFunction.center));
            end
        case 3 % input was also given
            if length(inputDimension) > length(obj.localModels{1}.validityFunction.center)
                warning(['WARNING: more dimensions to plot than input dimensions were submitted.' ...
                    'only the first ' num2str(length(obj.validityFunction.center)) ' dimensions are used']);
                inputDimension = inputDimension(1:length(obj.validityFunction.center));
            end
            plotInputFlag = true;
    end

    % check how much dimensions the inputs are
    AP = ones(1,obj.dimIn) * 0.5;
    switch length(inputDimension)
        case 1
            resolution = 30;
            input = linspace(0,1,resolution);
            inputVector = repmat(AP,resolution,1);
            inputVector(:,inputDimension) = input;

        case 2
            resolution = 30;
            input = linspace(0,1,resolution);
            [u1,u2] = meshgrid(input,input);
            inputVector = repmat(AP,resolution^2,1);
            inputVector(:,inputDimension) = [reshape(u1,[],1),reshape(u2,[],1)];
    end

    % calculate weighting
    normValidity = obj.calcNormValidity(inputVector);

    if plotInputFlag
        try
            normValidityInput = obj.calcNormValidity(inputPoint);
        catch
            warning('Input submitted was not of suitable size');
            plotInputFlag = false;
        end
    end
    
    % plot Weightings
    switch length(inputDimension)
        case 1
            legendEntries= {};
            for i=1:obj.getNumberOfLocalModels
                p(i) = plot(inputVector(:,inputDimension),normValidity(:,i));
                hold on;
                legendEntries{i} =['$LM_' num2str(i) '$']; 
                if plotInputFlag
                    plot(inputPoint,normValidityInput(i),'x','MarkerSize',14,'Color',p(i).Color);
                end
            end
            xlabel(['$u_' num2str(inputDimension(1)) '$']);
            ylabel('$\Phi_i$');
            
        case 2
            legendEntries= {};
            for i=1:obj.getNumberOfLocalModels
                p(i)=surf(u1,u2,reshape(normValidity(:,i),resolution,resolution));
                hold on;
                legendEntries{i} =['$LM_' num2str(i) '$']; 
            end
            xlabel(['$u_' num2str(inputDimension(1)) '$']);
            ylabel(['$u_' num2str(inputDimension(2)) '$']);
            zlabel('$\Phi_i$');
            if plotInputFlag
                plot(inputPoint,normValidityInput,'x','MarkerSize',12,'Color',p.Color);
            end
    end
   

    legend(p,legendEntries);
    xlim([0 1]);
    ylim([0 1]);
    
    
    
    
end