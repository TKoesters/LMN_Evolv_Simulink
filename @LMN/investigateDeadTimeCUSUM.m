function [TtLM_p,TtLM_n,cntfailed] = investigateDeadTimeCUSUM(obj,numberLMs,rangeTt,impulseOrStep)
%INVESTIGATEDEADTIMECUSUM Summary of this function goes here
%   Detailed explanation goes here
TtLM_p = [];
TtLM_n = [];

if nargin == 1
    numberLMs = 1;
    rangeTt = repmat([0 80],obj.dimIn,1);
    impulseOrStep = 'impulse';
elseif nargin==2
    rangeTt = repmat([0 80],obj.dimIn,1);
    impulseOrStep = 'impulse';
end

%% Set up LMN and train
if all(cellfun(@isempty,obj.zStaticInputFunc)) && all(isempty(cell2mat(obj.zDynInputDelay))) 
    zStaticFlag = true;
else
    zStaticFlag = false;
end

for i = 1 : obj.dimIn
    obj.xDynInputDelay{i} = rangeTt(i,2) - rangeTt(i,1);
    

    if zStaticFlag && numberLMs == 1
       obj.zStaticInputFunc{i}={@(u)u};   
    elseif zStaticFlag
        obj.zDynInputDelay{i} = rangeTt(i,2) - rangeTt(i,1);
    end
        
end

obj.maxNumberOfLocalModels = numberLMs;

% train lmn with lolimot
obj = obj.trainLOLIMOT;



%% cusum Method 
% method that first estimates the impulse response of each input to the
% output of the system.
%
% Second averaging of estimated impulse response to get ride of noise
%
% Third thresholding
% 
% for Ref: e.g. Bjoerklund2003 p. 20 and 21


variances = obj.calcParameterVariances;
cntfailed = 0;

if obj.offset
    index = 2;
else
    index = 1;
end



% iterate through every LM
for lm = 1 : obj.getNumberOfLocalModels
    
    if obj.offset
        startIndex = 2;
        endIndex = 1;
    else
        startIndex = 1;
        endIndex = 0;
    end

    
    
    % iterate through every input
    for i = 1 : obj.dimIn

        startIndex = endIndex + 1;
        endIndex = endIndex + obj.xDynInputDelay{i};
        s = obj.localModels{lm}.theta(startIndex:endIndex);
        s_n = -s;
        
        if strcmp(impulseOrStep,'step')
            s = cumsum(s);
        end
%         drift = variances(startIndex+1)^2;
%         threshold = variances(startIndex+1)^2 * 2;
        drift = std(s);
        threshold = std(s) * 1.5;
        
        drift_n = std(s_n);
        threshold_n = std(s_n) * 1.5;
        
        Ttfound = false;       
        Ttfound_n = false;       

        
        while ~Ttfound && ~Ttfound_n
        
            g_ts(1,i) = 0;
            g_ts_n(1,i) = 0;
            
            % iterate through the whole impulse response
            for ii = 2 : obj.xDynInputDelay{i} % everything is shifted once since 0 is also possible
                g_ts(ii,i) = g_ts(ii-1,i) + s(ii) - drift;
                g_ts_n(ii,i) = g_ts_n(ii-1,i) + s_n(ii) - drift_n;

                if g_ts(ii,i) < 0
                    g_ts(ii,i) = 0;
                elseif g_ts(ii,i) > threshold && ~Ttfound
                    TtLM_p(i,lm) = ii;
                    Ttfound=true;
                end
                
                if g_ts_n(ii,i) < 0
                    g_ts_n(ii,i) = 0;
                elseif g_ts_n(ii,i) > threshold_n && ~Ttfound_n
                    TtLM_n(i,lm) = ii;
                    Ttfound_n=true;
                end

            end

            if ~Ttfound
                if all(g_ts == 0)
                    TtLM_p(i,lm) = NaN;
                    Ttfound = true;
                else
                    drift = drift * 0.9;
                    threshold = threshold * 0.9;
                    disp('positive: drift and threshold were adjusted');
                end
            end
            
            if ~Ttfound_n 
                if all(g_ts_n == 0)
                    TtLM_n(i,lm) = NaN;
                    Ttfound_n = true;
                else
                    drift_n = drift_n * 0.9;
                    threshold_n = threshold_n * 0.9;
                    disp('negative: drift and threshold were adjusted');
                end
            end
            

        end
        
        % Visualisation for debuging
        figure('Name',['CUSUM: ' obj.info.inputDescription{i} '--' obj.info.outputDescription{1}]);
        subplot(2,1,1);
        x = (1 : length(s)) * 0.2;
        
        plot(x,s)
        hold on
        plot(x,g_ts(:,i))
        %plot(x,cumsum(s))
        xlabel('time $t$[s]');
        ylabel(substituteRAW(obj.info.outputDescription{1}));
        legend('$\theta(k)$','CUSUM value','step response');
        try
        plot([TtLM_p(i),TtLM_p(i)]*0.2,[min(cumsum(s)),max(cumsum(s))],'r--');
        end
        grid on;
        grid minor;
        
        
        subplot(2,1,2);
        plot(x,s_n)
        hold on
        plot(x,g_ts_n(:,i))
        plot(x,cumsum(s_n))
        xlabel('time $k$');
        ylabel(substituteRAW(obj.info.outputDescription{1}));
        try
        plot([TtLM_n(i),TtLM_n(i)]*0.2,[min([cumsum(s_n);0]),max([0;cumsum(s_n)])],'r--');
        end
        grid on;
        grid minor;
    end
     
end






end

