function [obj] = initializeLMNforAdaption(obj,numberDatapoints)
%INITIALIZELMNFORADAPTION Summary of this function goes here
%   Detailed explanation goes here

%#codegen

    %% input handling
    if nargin == 1
        numberDatapoints = 0;
    end

    %% Initialize deadtime puffer
    for i = 1 : obj.dimIn
        % add dead time of 1 to each input since the current input does not
        % influence the current output ???
        % Code Generation does not support: 
        % if all(isempty(cell2mat(obj.xDynInputDelay(:))))
        flag = true;
        for ii = 1 : obj.dimIn
            if ~isempty(obj.xDynInputDelay{i})
                flag = false;
            end
        end
           
        if flag
            % dont do anything 
        else
            obj.xDeadTimes{i} = obj.xDeadTimes{i} + 1;
        end


        % was not supported by code generation
%         if obj.xDeadTimes{i} == 0
%             obj.xDeadTimeDataPuffer{i} = 0;
%         else
%             obj.xDeadTimeDataPuffer{i} = double(ones(1,obj.xDeadTimes{i}) * 0.5);
%         end

        % code generation version
        % find max deadtime
        maxDeadTime = getMaxDeadTime(obj.xDeadTimes);
        obj.xDeadTimeDataPuffer = ones(obj.dimIn,maxDeadTime) * 0.5;

        if all(isempty(cell2mat(obj.zDynInputDelay(:))))
            % dont do anything 
        else
            obj.zDeadTimes{i} = obj.zDeadTimes{i} + 1;
        end

%         if obj.zDeadTimes{i} == 0
%             obj.zDeadTimeDataPuffer{i} = [];
%         else
%             obj.zDeadTimeDataPuffer{i} = double(ones(1,obj.zDeadTimes{i}) * 0.5);
%         end

        % code generation verison
        maxDeadTime = getMaxDeadTime(obj.zDeadTimes);
        obj.zDeadTimeDataPuffer = ones(obj.dimIn,maxDeadTime);
    end
    
    
     %% Initilize Regularisation matrix if needed
    if ~strcmp(obj.RegOptions.method,'none')
       % see if regularisation method was changed after training
%        for i = 1 : obj.getNumberOfLocalModels
%           obj.localModels{i} = obj.localModels{i}.updateRegInformation(obj.RegOptions); 
%        end
        
       % build regularisation matrix
       obj.RegularisationMatrix = obj.localModels{1}.buildRegularizationMatrix; 
    end

    %% Set Adaption Flag
    obj.adaptionFlag = true;
    obj = obj.setLocalAdaptionFlag(true);
    
    
    %% Initilize local model parameters for adaption

    % initialize every possibility to get ride of compilation problems
    % RLS 
    numberOfLocalParameter = obj.localModels{1}.calcNumberOfLocalParameters;
    P_k = eye(numberOfLocalParameter) * 100;
    gamma_k = zeros(numberOfLocalParameter,1); 
    for i = 1 : obj.getNumberOfLocalModels
       obj.localModels{i}.P_k = P_k;
       obj.localModels{i}.gamma_k = gamma_k;
    end

    % LRLS
    if ~isempty(obj.xRegressor)
        weights = obj.calcNormValidity(obj.zRegressor);
        for i = 1 : obj.getNumberOfLocalModels
%                                     M_k = ;
%                 Z_k = (obj.xRegressor'*obj.outputTrain);

           obj.localModels{i}.M_k = (obj.xRegressor'*(weights(:,i).*obj.xRegressor));
           obj.localModels{i}.Z_k = ((weights(:,i).*obj.xRegressor)'*obj.normOutput(obj.outputTrain));
           obj.localModels{i}.N_eff = length(obj.xRegressor(:,1));
           obj.localModels{i}.Regler.I = ones(obj.dimIn,1);
           obj.localModels{i}.Regler.P = ones(1,1);
           obj.localModels{i}.RegAdaption = ones(obj.dimIn,1);
        end
    else
        M_k = zeros(numberOfLocalParameter);
        Z_k = zeros(numberOfLocalParameter,1); 
        for i = 1 : obj.getNumberOfLocalModels
           obj.localModels{i}.M_k = M_k;
           obj.localModels{i}.Z_k = Z_k;
           obj.localModels{i}.Regler.I = ones(obj.dimIn,1);
           obj.localModels{i}.RegAdaption = ones(obj.dimIn,1);
           obj.localModels{i}.Regler.P = ones(1,1);
        end
    end
%             
%     switch obj.AdaptOptions.methodParameterUpdate
%         
%         case 'RLS'
%             numberOfLocalParameter = obj.localModels{1}.calcNumberOfLocalParameters;
%             P_k = eye(numberOfLocalParameter) * 100;
%             gamma_k = zeros(numberOfLocalParameter,1); 
%             for i = 1 : obj.getNumberOfLocalModels
%                obj.localModels{i}.P_k = P_k;
%                obj.localModels{i}.gamma_k = gamma_k;
%             end
%             
%         case 'RLS-VF'
%             numberOfLocalParameter = obj.localModels{1}.calcNumberOfLocalParameters;
%             P_k = eye(numberOfLocalParameter) * 100;
%             gamma_k = zeros(numberOfLocalParameter,1); 
%             for i = 1 : obj.getNumberOfLocalModels
%                 obj.localModels{i}.P_k = P_k;
%                 obj.localModels{i}.gamma_k = gamma_k;
%             end
% 
%         case {'LRLS','LRLS-VR'}
%             numberOfLocalParameter = obj.localModels{1}.calcNumberOfLocalParameters;
%             if ~isempty(obj.xRegressor)
%                 weights = obj.calcNormValidity(obj.zRegressor);
%                 for i = 1 : obj.getNumberOfLocalModels
% %                                     M_k = ;
% %                 Z_k = (obj.xRegressor'*obj.outputTrain);
% 
%                    obj.localModels{i}.M_k = (obj.xRegressor'*(weights(:,i).*obj.xRegressor));
%                    obj.localModels{i}.Z_k = ((weights(:,i).*obj.xRegressor)'*obj.normOutput(obj.outputTrain));
%                    obj.localModels{i}.N_eff = length(obj.xRegressor(:,1));
%                    obj.localModels{i}.Regler.I = ones(obj.dimIn,1);
%                    obj.localModels{i}.RegAdaption = ones(obj.dimIn,1);
%                 end
%             else
%                 M_k = zeros(numberOfLocalParameter);
%                 Z_k = zeros(numberOfLocalParameter,1); 
%                 for i = 1 : obj.getNumberOfLocalModels
%                    obj.localModels{i}.M_k = M_k;
%                    obj.localModels{i}.Z_k = Z_k;
%                    obj.localModels{i}.Regler.I = ones(obj.dimIn,1);
%                    obj.localModels{i}.RegAdaption = ones(obj.dimIn,1);
%                 end
%             end
%             
%             
%         case {'LRLS-VF','LRLS-VR-VF'}
%             numberOfLocalParameter = obj.localModels{1}.calcNumberOfLocalParameters;
%             if ~isempty(obj.xRegressor)
%                 weights = obj.calcNormValidity(obj.zRegressor);
%                 for i = 1 : obj.getNumberOfLocalModels
% %                                     M_k = ;
% %                 Z_k = (obj.xRegressor'*obj.outputTrain);
% 
%                    obj.localModels{i}.M_k = (obj.xRegressor'*(weights(:,i).*obj.xRegressor));
%                    obj.localModels{i}.Z_k = ((weights(:,i).*obj.xRegressor)'*obj.normOutput(obj.outputTrain));
%                    obj.localModels{i}.N_eff = length(obj.xRegressor(:,1));
%                    obj.localModels{i}.Regler.I = ones(obj.dimIn,1);
%                    obj.localModels{i}.RegAdaption = ones(obj.dimIn,1);
%                 end
%             else
%                 M_k = zeros(numberOfLocalParameter);
%                 Z_k = zeros(numberOfLocalParameter,1); 
%                 for i = 1 : obj.getNumberOfLocalModels
%                    obj.localModels{i}.M_k = M_k;
%                    obj.localModels{i}.Z_k = Z_k;
%                    obj.localModels{i}.Regler.I = ones(obj.dimIn,1);
%                    obj.localModels{i}.RegAdaption = ones(obj.dimIn,1);
%                 end
%             end
% 
%             
%        
%         case 'LMS'
%             
%         case 'LLMS'
%         
%         otherwise
%             error('ERROR: No valid method were chosen for update local model parameters. Choose RLS, RLS-VF, LRLS, LMS, LLMS');
%     end
    
    %% Initialize x-Regressor
    if obj.offset
        obj.xRegressor = [1 ones(1,obj.localModels{1}.calcNumberOfLocalParameters-1).*0.5]; 
    else
         obj.xRegressor = ones(1,obj.localModels{1}.calcNumberOfLocalParameters).*0.5; 
    end
    
    
    %% Initialize z-Regressor
    obj.zRegressor = ones(1,obj.localModels{1}.calcNumberOfZParameter).*0.5; 
        
    %% Initialize Filter Puffer
    obj = obj.initializeFilter;    

    %% Initialize which inputs should be regularized
    obj.AdaptOptions.inputs4Regularization = obj.RegOptions.lambda~=0;

    %% Initialize Regularization matrix
    if isempty(obj.RegularisationMatrix)
        obj.RegularisationMatrix = zeros(numberOfLocalParameter);
    end

    %% Initialize history for adaption
    if obj.AdaptOptions.dataCollection && numberDatapoints>0
        obj.history.adaptionStatus = zeros(length(obj.AdaptOptions.information2plot),obj.getNumberOfLocalModels,obj.dimIn,numberDatapoints);
    else
        obj.history.adaptionStatus = [];
    end
  
end


%% functions 
function out = getMaxDeadTime(in)
    out = 0;
    for i  = 1 : length(in)
        out = max(out,in{i});
    end
end

