function regressor = buildZRegressor(obj,input,output,plotFlag)
%BUILDREGRESSOR Summary of this function goes here
%   Detailed explanation goes here
%     regressor = [];
%     
%     if nargin==2
%         output = [];
%     end 
%     
%     % iterate through all dynamic models
%     for i = 1 : length(obj.dynamicModels)
%         if ~isempty(obj.dynamicModels{i})
%             [dynRegressor{i}, outputRegressor]= obj.dynamicModels{i}.buildZRegressor(input(:,i),output);
%         else
%             dynRegressor{i} = [];
%         end
%         regressor = [regressor, dynRegressor{i}];
%     end
% 
%     % add output Regressor for ARX models
%     if ~isempty(obj.zDynOutputDelay)
%        regressor = [regressor, outputRegressor];
%     end
% 
%     
%     % iterate through all static models
%     regressorStatic = [];
%     for i = 1 : length(obj.staticModels)
%         if ~isempty(obj.staticModels{i}.zStaticInputFunc)
%             staticRegressor{i} = obj.staticModels{i}.buildZRegressor(input(:,i));
%         else
%             staticRegressor{i} = [];
%         end
%         regressorStatic = [regressorStatic, staticRegressor{i}];
%     end
%     
%     % check if static and dynamic has to be shifted
%     if obj.staticDelay == 0
%         regressor = [regressor(1:end-1,:),regressorStatic(2:end,:)];
%     elseif obj.staticDelay == 1
%         regressor = [regressor(1:end-1,:),regressorStatic(1:end-1,:)];
%     end
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    if ~isempty(obj.zRegressor) && obj.trainFlag
        regressor = obj.zRegressor;
    else
        if nargin == 2
            output= [];
        end

        nParameter = obj.calcNumberOfZParameter;
        regressor = zeros(length(input(:,1)),nParameter);
        collumnPointer = 1;

        % incorporate dead Times if needed
        if ~plotFlag
            input = obj.zIncorpDeadTimes(input);
        end

        % iterate through all dynamic models
        for i = 1 : length(obj.dynamicModels)
            if ~isempty(obj.dynamicModels{i})
                [dynRegressor, outputRegressorTemp]= obj.dynamicModels{i}.buildZRegressor(input(:,i),output);
                if ~(isempty(dynRegressor))
                    regressor(:,collumnPointer:collumnPointer+length(dynRegressor(1,:))-1) = dynRegressor(1:end-1,:);
                    collumnPointer = collumnPointer+length(dynRegressor(1,:));
                end
            end
        end


        % iterate through all static models
        for i = 1 : length(obj.staticModels)
            if ~isempty(obj.staticModels{i}.zStaticInputFunc)
                staticRegressor = obj.staticModels{i}.buildZRegressor(input(:,i));
                if obj.staticDelay == 0
                    regressor(:,collumnPointer:collumnPointer+length(staticRegressor(1,:))-1) =...
                        staticRegressor(2:end,:);
                elseif obj.staticDelay == 1
                    regressor(:,collumnPointer:collumnPointer+length(staticRegressor(1,:))-1) =...
                        staticRegressor(1:end-1,:);
                end
                collumnPointer = collumnPointer+length(staticRegressor(1,:));
            end
        end


        % add output Regressor for ARX models
        if ~isempty(obj.zDynOutputDelay{1})
            if isempty(outputRegressorTemp)
                outputRegressor = zeros(nData+1,0);
            else
                outputRegressor = outputRegressorTemp;
            end
            regressor(:,collumnPointer:collumnPointer+sum(obj.zDynOutputDelay{1})-1) = outputRegressor(1:end-1,:);
            collumnPointer = collumnPointer+sum(obj.zDynOutputDelay{1});       
        end


        
        
        % norm seperatly if different functions for one input were choose
%         if obj.trainFlag
%             for i = 1 : length(regressor(1,:))
%                 regressor(:,i) = normZInput(regressor(:,i));
%             end
%         end
    end
    
    
end

function normedRegressor = normZInput(regressor)

    minValue = min(regressor);
    maxValue = max(regressor);
    
    if minValue ~= maxValue
        normedRegressor = (regressor-minValue) ./(maxValue - minValue);
    else
        normedRegressor = regressor;
    end
end


