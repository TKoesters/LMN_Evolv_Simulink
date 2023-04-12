function obj = updateRegressors(obj,input,output)
%UPDATEREGRSSORS Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 3
        % only input was submitted 
        % should not happen since current output is updated
        warning('No output was given to function updateRegressor: currentOutput cannot be updated');
        output = [];
    end

    % Norm input data
    inputNormed = obj.normInputs(input);
    
    % Update Deadtime Datapuffer
    [obj, xInputTt, zInputTt] = obj.updateDeadtimeDatapuffer(inputNormed);
    
    % Filter Data if needed
    [obj, xInputTtFiltered, zInputTtFiltered] = obj.filterData(xInputTt, zInputTt);
    
    %% Update x-Regressor
     
    if obj.offset
        range = [2 2];
    else
        range = [1 1];
    end
    
    % dyn Regressor (FIR)
    for i = 1 : length(obj.localModels{1}.dynamicModels)
        if ~isempty(obj.xDynInputDelay{i})
            range(2) = range(1) + obj.xDynInputDelay{i}-1;
            obj.xRegressor(range(1):range(2)) = [xInputTtFiltered(i) obj.xRegressor(range(1):range(2)-1)];
            range(1) = range(2)+1;
        end
    end
    
    % static Regressor 
    
    for i = 1 : length(obj.localModels{1}.staticModels)
        if ~isempty(obj.localModels{1}.staticModels{i}.xStaticInputFunc)
                
            % update range
            range(2) = range(1) + length(obj.zStaticInputFunc{i})-1;
            help = obj.localModels{1}.staticModels{i}.buildRegressor(xInputTtFiltered(i));
            % remove first line because its only used in batch
            % regression
            obj.xRegressor(range(1):range(2)) = help(end,:);
                
            range(1) = range(2)+1;
        end
    end
    
    % only add static Regressor of available
%     if range(1) > length(obj.xRegressor)
%         obj.xRegressor(range(2)+1:end) = staticRegressor;
%     end
    
    %% Update z-Regressor 
    % dyn Regressor (FIR)
    range = [1 1];
    
    for i = 1 : length(obj.localModels{1}.dynamicModels)
        if ~isempty(obj.zDynInputDelay{i})
            range(2) = range(1) + obj.zDynInputDelay{i}-1;
            obj.zRegressor(range(1):range(2)) = [zInputTtFiltered(i) obj.zRegressor(range(1):range(2)-1)];
            range(1) = range(2)+1;
        end
    end
    indexBeginStaticRegressor = range(1);
    
    % static Regressor 
    staticRegressor = [];
    for i = 1 : length(obj.localModels{1}.staticModels)
        if ~isempty(obj.localModels{1}.staticModels{i}.zStaticInputFunc)
            
            % update range
            range(2) = range(1) + length(obj.zStaticInputFunc{i})-1;
            
            help = obj.localModels{1}.staticModels{i}.buildZRegressor(zInputTtFiltered(i));
            % remove first line because its only used in batch
            % regression
            staticRegressor(range(1):range(2)) = help(end,:);
                
            range(1) = range(2)+1;
        end
    end
    
    obj.zRegressor(indexBeginStaticRegressor:end) = staticRegressor;
        
    
    %% update current output 
    normedOutput = obj.normOutput(output);
    obj.currentOutput = normedOutput;
    
    
end

