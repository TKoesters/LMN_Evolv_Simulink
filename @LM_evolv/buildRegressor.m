function regressor = buildRegressor(obj,input,output)
%BUILDREGRESSOR build Regressor matrix for LMN
%   Builds regressor out of 4 parts
%
%   1) Offset if set
%   2) Dynamic input regressor part (FIR)
%   3) Static  input regressor part (static)
%   4) Dynamic output regrossor part (ARX)
%
%--------------------------------------------------------------------------
    
    if ~isempty(obj.xRegressor) && obj.trainFlag
        regressor = obj.xRegressor;
    else
        if nargin == 2
            output= [];
        end

        nParameter = obj.calcNumberOfLocalParameters;
        nData = length(input(:,1));
        regressor = zeros(nData,nParameter);
        collumnPointer = 1;


        % incorporate dead Times if needed
        input = obj.xIncorpDeadTimes(input);

        % add offset when needed
        if obj.offset
            regressor(:,collumnPointer) = ones(length(regressor(:,1)),1);
            collumnPointer = 2;
        end

        % iterate through all dynamic models
        dynRegressor  = [];
        for i = 1 : length(obj.dynamicModels)
            if ~isempty(obj.dynamicModels{i})
                [dynRegressor, outputRegressorTemp]= obj.dynamicModels{i}.buildRegressor(input(:,i),output);
                regressor(:,collumnPointer:collumnPointer+length(dynRegressor(1,:))-1) = dynRegressor(1:end-1,:);
                    collumnPointer = collumnPointer+length(dynRegressor(1,:));
            end
        end


        % iterate through all static models
        for i = 1 : length(obj.staticModels)
            if ~isempty(obj.staticModels{i}.xStaticInputFunc)
                staticRegressor = obj.staticModels{i}.buildRegressor(input(:,i));
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
        if ~isempty(obj.dynamicModels{i})
            if strcmp(obj.dynamicModels{i}.form,'ARX') 
                if isempty(outputRegressorTemp)
                    outputRegressor = zeros(nData+1,0);
                else
                    outputRegressor = outputRegressorTemp;
                end
                regressor(:,collumnPointer:collumnPointer+sum(obj.xDynOutputDelay{1})-1) = outputRegressor(1:end-1,:);
                collumnPointer = collumnPointer+sum(obj.xDynOutputDelay{1});
            end
        end


        % check if static and dynamic has to be shifted
    %     if obj.staticDelay == 0
    %         regressor = [regressorTemp(1:end-1,:),regressorStatic(2:end,:)];
    %     elseif obj.staticDelay == 1
    %         regressor = [regressorTemp(1:end-1,:),regressorStatic(1:end-1,:)];
    %     end
    %     
    end

end

