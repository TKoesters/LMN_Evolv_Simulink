function obj  = updateLocalModel(obj,input,output,normValidity,adaptOptions,RegularisationMatrix,dimIn,indexInput,globalError)
%UPDATELOCALMODEL Summary of this function goes here
%   Detailed explanation goes here
    
    x_k = input;
    y_k = output;
    weight = normValidity;

    % calc global or local error
    switch adaptOptions.localORglobalError
        case 'local'
            obj.error = obj.error*(1-adaptOptions.errorFilter) + adaptOptions.errorFilter * (y_k - x_k * obj.theta);
        case 'global'
            obj.error = globalError;
    end

    


    switch adaptOptions.methodParameterUpdate
        
        case 'RLS'
        %% RLS - recursive least square algorithm
        %
        % - standart recursive least square algorithm with forgetting
        %   factor
        % - regularisastion can be used by defining appropriate P_0 
        % - regularisation vanishes over time 
        % - mathematical formulation taken from book Prof. Nelles 
        %   (Section 3.2)
        
        % get fixed forgetting factor
        obj.forgetting = adaptOptions.forgettingFactor;

        obj.N_eff = obj.N_eff * obj.forgetting + 1;

        obj.gamma_k = 1/(x_k*obj.P_k*x_k'+obj.forgetting/weight) * obj.P_k *x_k'; %as stated in book of nelles
        
        obj.theta = obj.theta + obj.gamma_k * obj.error;

        obj.P_k = 1/obj.forgetting * (eye(length(x_k)) - obj.gamma_k * x_k) * obj.P_k;
               
%         %1) calculate measurement of MK invertebility
%         obj.conditionMK = cond(obj.M_k);
%         obj.conditionMK_Reg = cond(inv(obj.P_k));
%         %obj.sigma_k = obj.forgetting * obj.sigma_k + (1 - x_k/obj.M_k*x_k') * error^2;
%         obj.detMK_inv = det(inv(obj.M_k));
%         obj.detMKReg_inv = det(inv(obj.M_k));
%         obj.diagP = diag(inv(obj.M_k));
%         obj.diagPReg = diag(inv(obj.M_k));
%         obj.traceMk = trace(inv(obj.M_k));
        obj.traceMkReg = trace(obj.P_k);
%         obj.xTXXx = x_k*obj.gamma_k;
%         obj.xTXXxReg = x_k*obj.gamma_k;


        case 'RLS-VF'
        %% RLS-VF - recursive least square algorithm with variable
        % forgetting
        %
        % - standart recursive least square algorithm with variable forgetting
        %   factor
        % - regularisastion can be used by defining appropriate P_0 
        % - regularisation vanishes over time 
        % - mathematical formulation taken from book Fortescue et. al.
        %   Implementation of Self-tuning Regulators
        %   with Variable Forgetting Factors
        
        obj.N_eff = obj.N_eff * obj.forgetting + 1;

        obj.gamma_k = 1/(x_k*obj.P_k*x_k'+obj.forgetting/weight) * obj.P_k *x_k'; %as stated in book of nelles
        
        obj.theta = obj.theta + obj.gamma_k * obj.error;
        
        obj.forgetting = 1 - (1 - x_k * obj.gamma_k) * obj.error^2/adaptOptions.Sigma0;
        obj.P_k = 1/obj.forgetting * (eye(length(x_k)) - obj.gamma_k * x_k) * obj.P_k;
            
        obj.traceMkReg = trace(obj.P_k);


        case 'LRLS'
        %% LRLS - leaky recursive least square algorithm
        %
        % - recursive least square algorithm with forgetting factor
        % - is able to use regularisation that does not vanish over time 
        % - mathematical forulation made by Koesters/Illg (see file RRLS)
        
        % get fixed forgetting factor
        obj.forgetting = adaptOptions.forgettingFactor;

        obj.N_eff = obj.N_eff * obj.forgetting + 1;

        %tic
        obj.M_k = obj.M_k * obj.forgetting + x_k' * x_k * weight; % As stated from Koesters 
        obj.Z_k = obj.Z_k * obj.forgetting + x_k' * y_k * weight;
        if isempty(RegularisationMatrix)
            obj.theta = (obj.M_k)\...
            obj.Z_k;
        else
            if adaptOptions.compensateNeff
                obj.theta = (obj.M_k + obj.N_eff * RegularisationMatrix)\...
                    obj.Z_k;
            else
                obj.theta = (obj.M_k + RegularisationMatrix)\...
                    obj.Z_k;
            end
        end
        

         %1) calculate measurement of MK invertebility
%         obj.conditionMK = cond(obj.M_k);
%         obj.conditionMK_Reg = cond(obj.M_k + RegularisationMatrix);
%         obj.sigma_k = obj.forgetting * obj.sigma_k + (1 - x_k/obj.M_k*x_k') * obj.error^2;
%         obj.detMK_inv = det(inv(obj.M_k));
%         obj.detMKReg_inv = det(inv(obj.M_k + RegularisationMatrix));
%         obj.diagP = diag(inv(obj.M_k));
%         obj.diagPReg = diag(inv(obj.M_k + RegularisationMatrix));
%         obj.traceMk = trace(inv(obj.M_k));
        obj.traceMkReg = trace(inv(obj.M_k+RegularisationMatrix));
%         obj.xTXXx = x_k/obj.M_k*x_k';
%         obj.xTXXxReg = x_k/(obj.M_k+RegularisationMatrix)*x_k';

        %Time = toc;
        %obj.compTime = [Time; obj.compTime];
        
        case 'LRLS-VF'
        %% LRLS-VF - leaky recursive least square algorithm with variable
        % forgetting
        %
        % - recursive least square algorithm with variabele forgetting factor
        % - is able to use regularisation that does not vanish over time 
        % - mathematical forulation made by Koesters/Illg (see file RRLS)
        if isempty(obj.forgetting)
            obj.forgetting = adaptOptions.forgettingFactor;
        end

        %tic
        obj.N_eff = obj.N_eff * obj.forgetting + 1;
        
        obj.M_k = obj.M_k * obj.forgetting + x_k' * x_k * weight; 
        obj.Z_k = obj.Z_k * obj.forgetting + x_k' * y_k * weight;
        if isempty(RegularisationMatrix)
            obj.theta = (obj.M_k)\...
            obj.Z_k;
        else
            if adaptOptions.compensateNeff
                obj.theta = (obj.M_k + obj.N_eff * RegularisationMatrix)\...
                    obj.Z_k;
            else
                obj.theta = (obj.M_k + RegularisationMatrix)\...
                    obj.Z_k;
            end
        end
        
        % update of forgetting factor
        obj.forgetting = 1 - (1 - x_k/(obj.M_k + RegularisationMatrix)*x_k') * obj.error^2 / adaptOptions.Sigma0;
        obj.forgetting = max([0.95,obj.forgetting]);


         %1) calculate measurement of MK invertebility
%         obj.conditionMK = cond(obj.M_k);
%         obj.conditionMK_Reg = cond(obj.M_k + RegularisationMatrix);
%         obj.sigma_k = obj.forgetting * obj.sigma_k + (1 - x_k/obj.M_k*x_k') * obj.error^2;
%         obj.detMK_inv = det(inv(obj.M_k));
%         obj.detMKReg_inv = det(inv(obj.M_k + RegularisationMatrix));
%         obj.diagP = diag(inv(obj.M_k));
%         obj.diagPReg = diag(inv(obj.M_k + RegularisationMatrix));
%         obj.traceMk = trace(inv(obj.M_k));
        obj.traceMkReg = trace(inv(obj.M_k+RegularisationMatrix));
%         obj.xTXXx = x_k/obj.M_k*x_k';
%         obj.xTXXxReg = x_k/(obj.M_k+RegularisationMatrix)*x_k';

        %Time = toc;
        %obj.compTime = [Time; obj.compTime];


        case {'LRLS-VR','LRLS-VR-VF'}
        %% LRLS-VR & LRLS-VR-VF - leaky recursive least square algorithm with variable
        % regularization (and variable forgetting)
        %
        % - recursive least square algorithm with forgetting factor
        % - is able to use regularisation that does not vanish over time 
        % - mathematical forulation made by Koesters/Illg (see file RRLS)
        % - Addtion: VR via different options (trace, det, cond...)
        if isempty(obj.forgetting)
            obj.forgetting = adaptOptions.forgettingFactor;
        end
        
        obj.N_eff = obj.N_eff * obj.forgetting + 1;

        %tic
        obj.M_k = obj.M_k * obj.forgetting + x_k' * x_k * weight; % As stated from Koesters 
        obj.Z_k = obj.Z_k * obj.forgetting + x_k' * y_k * weight;

        % Adapt Regularistaion Matrix
        % create weight vector
        weightvector = ones(obj.nParameter,1);
        for i = 1 : dimIn
            weightvector(indexInput(i,1):indexInput(i,2)) = max([0,obj.RegAdaption(i)]);
        end
        RegularisationMatrix = weightvector .* RegularisationMatrix;

        if isempty(RegularisationMatrix)
            obj.theta = (obj.M_k)\...
            obj.Z_k;
        else
            if adaptOptions.compensateNeff
                obj.theta = (obj.M_k + obj.N_eff * RegularisationMatrix)\...
                    obj.Z_k;
            else
                obj.theta = (obj.M_k + RegularisationMatrix)\...
                    obj.Z_k;
            end
        end
        
        if strcmp(adaptOptions.methodParameterUpdate,'LRLS-VR-VF')
            % Update of forgetting factor
            switch adaptOptions.methodForgetting
                case 'error'
                    obj.forgetting = 1 - abs(obj.error) * weight * (1 - adaptOptions.Sigma0);
                case 'fortesque'
                    %with Regularization
                    obj.forgetting = 1 - (1 - x_k/(obj.M_k + RegularisationMatrix)*x_k' * weight) * obj.error^2 * weight^2/ adaptOptions.Sigma0;
            
                    %without Regularization
                    %obj.forgetting = 1 - (1 - x_k/(obj.M_k)*x_k') * obj.error^2 / adaptOptions.Sigma0;
            end
        end


        if obj.forgetting>1 
            warning('forgetting over 1');
        end

        obj.forgetting = max([0.95,obj.forgetting]);
        % Update of Regularisation strength

%         %1) calculate measurement of MK invertebility
%         obj.conditionMK = cond(obj.M_k);
%         obj.conditionMK_Reg = cond(obj.M_k + RegularisationMatrix);
%         obj.sigma_k = obj.forgetting * obj.sigma_k + (1 - x_k/obj.M_k*x_k') * obj.error^2;
%         obj.detMK_inv = det(inv(obj.M_k));
%         obj.detMKReg_inv = det(inv(obj.M_k + RegularisationMatrix));
%         obj.diagP = diag(inv(obj.M_k));
%         obj.diagPReg = diag(inv(obj.M_k + RegularisationMatrix));
%         obj.traceMk = trace(inv(obj.M_k));
%         obj.traceMkReg = trace(inv(obj.M_k+RegularisationMatrix));%*obj.M_k*inv(obj.M_k+RegularisationMatrix));
%         obj.xTXXx = x_k/obj.M_k*x_k';
%         obj.xTXXxReg = x_k/(obj.M_k+RegularisationMatrix)*x_k';
% 
%         criterion = 'trace';
%         factor = 0.01;
%         
%         % idea only look at information matrix dont consider regularization
%         % yet --> information increase or decrease result of data 
%         switch criterion 
%             case 'trace'
%                 obj.valueDiff = log(obj.traceMk) - obj.valueInfo; % use log since behavior is exponential
%                 obj.valueInfo = obj.valueInfo + obj.valueDiff;
%             case 'det'
%                 obj.valueDiff = log(obj.detMK_inv) - obj.valueInfo;
%                 obj.valueInfo = obj.valueInfo + obj.valueDiff;
%         end


        Regler = 'PI-Regler-MISO';
        switch Regler
            case '2Punkt'
                % 2 Punkt Regler 
                if obj.valueDiff > 0
                    obj.RegAdaption = obj.RegAdaption + factor;
                elseif obj.valueDiff < 0
                    obj.RegAdaption = obj.RegAdaption - factor;
                else
                    % do nothing
                end
             
            case 'P'
                % P Regler 
                Kp = 0.001;
                obj.RegAdaption = 1 + obj.valueDiff * Kp;
                
            case 'PI'
                % PR Regler
                Kp = 0.1;
                obj.RegAdaption = obj.RegAdaption + Kp * obj.valueDiff;

            case 'Product 2Punkt'
                factor=0.005;
                if obj.valueDiff > 0
                    obj.RegAdaption = obj.RegAdaption * (1+ factor * obj.valueDiff);
                elseif obj.valueDiff < 0
                    obj.RegAdaption = obj.RegAdaption * (1- factor * obj.valueDiff);
                else
                    % do nothing
                end


            case 'Product P'
                factor=0.5;
                obj.RegAdaption = obj.RegAdaption * (1+ factor * obj.valueDiff);

            case 'Product P+'   
                factor=0.5;
                factor2 = 0.001;
                sollTrace = 2.5;

                obj.RegAdaption = obj.RegAdaption * (1+ factor * obj.valueDiff + factor2 * (sollTrace-obj.traceMkReg));
                

            case 'PI-Regler'
                sollTrace = 1000;
                
                Kp = 10;
                TI = 10;

                e_regler = -sollTrace + obj.traceMkReg;
                if isempty(obj.u_regler)
                    obj.u_regler = obj.RegOptions.lambda;
                end
                obj.Regler.I = max([0, obj.Regler.I + e_regler * 1/TI]);
                obj.Regler.P = Kp * e_regler;
                obj.u_regler = obj.Regler.I + obj.Regler.P;
                obj.u_regler = max([0,obj.u_regler]);
                obj.RegAdaption = obj.u_regler;%/obj.RegOptions.lambda;

            case 'PI-Regler-MISO'
                sollTrace = adaptOptions.desiredTrace;
                invMKRegDiag = diag(inv(obj.M_k + RegularisationMatrix));

                Kp = 0; %0.0005;
                TI = 20;
                traceMKReg = zeros(dimIn,1);
                for i = 1 : dimIn
                    if adaptOptions.inputs4Regularization(i)  
                        traceMKReg(i) = sum(invMKRegDiag(indexInput(i,1):indexInput(i,2)));
                        e_regler = -sollTrace + traceMKReg(i);
                        obj.Regler.I(i) = max([0, obj.Regler.I(i) + e_regler * 1/TI]);
                        obj.Regler.P = Kp * e_regler;
                        obj.u_regler = obj.Regler.I(i) + obj.Regler.P;
                        obj.u_regler = min(max([0,obj.u_regler]),100);
                        obj.RegAdaption(i) = obj.u_regler;
                    else
                        obj.RegAdaption(i) = 1;
                    end         
                end
                obj.traceMkReg = traceMKReg;


            case 'PI-Regler-UB'
                sollTrace = 1.5;
                
                Kp = 20;
                TI = 1;

                e_regler = max([0,-sollTrace + obj.traceMkReg]);
                if isempty(obj.u_regler)
                    obj.u_regler = obj.RegOptions.lambda;
                end
                obj.Regler.I = obj.Regler.I + e_regler * 1/TI;
                obj.Regler.P = Kp * e_regler;
                obj.u_regler = obj.Regler.I + obj.Regler.P;
                obj.u_regler = max([0,obj.u_regler]);
                obj.RegAdaption = obj.u_regler;%/obj.RegOptions.lambda;

            otherwise
        end


        %Time = toc;
        %obj.compTime = [Time; obj.compTime];

        case 'LMS'
            
        case 'LLMS'
        
        otherwise
            error('ERROR: No valid method were chosen for update local model parameters. Choose RLS, LRLS, LMS, LLMS');
    end


end

