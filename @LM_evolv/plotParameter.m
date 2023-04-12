function plotParameter(obj,option,axesHandle)
%PLOTPARAMETER Summary of this function goes here
%   Detailed explanation goes here
if nargin==2
    axesHandle = gca;
end

if nargin==1
    axesHandle = gca;
    option.inputs = 'all';
    option.Dyn = 'none';
end


% create Parameter range vector
paraRange = [1 1];


%% offset
if obj.offset
    if strcmp(option.inputs,'all') || strcmp(option.inputs,'offset')
        plot(obj.theta(paraRange(1):paraRange(2)),'x','MarkerSize',10);
        ylabel('offset');
    end
    paraRange = [2 2];
end

%% dynamic Models

% find FIR models
if isempty(obj.xDynOutputDelay{1})
    for i = 1 : length(obj.xDynInputDelay)
        if ~isempty(obj.xDynInputDelay{i})
            paraRange(2) = paraRange(2) + obj.xDynInputDelay{i} - 1;
            if strcmp(option.inputs,'all') || (strcmp(option.inputs,'dynamic') && strcmp(option.Dyn,'imp'))
                axes(axesHandle{i});
                plot(obj.theta(paraRange(1):paraRange(2)));
                hold on;
                xlabel(['Impulse Response input ' num2str(i)]);
                ylabel('$k$');
            elseif strcmp(option.inputs,'all') || (strcmp(option.inputs,'dynamic') && strcmp(option.Dyn,'step'))
                axes(axesHandle{i});
                plot(cumsum(obj.theta(paraRange(1):paraRange(2))));
                hold on;
                xlabel(['Step Response input ' num2str(i)]);
                ylabel('$k$');
            end
            paraRange = [paraRange(2)+1, paraRange(2)+1];
        end
    end
else
% ARX models (dont implemented yet)
disp('Plotting of ARX models not implemented yet');
end


%% static Models
for i = 1 : length(obj.xStaticInputFunc)
    if (strcmp(option.inputs,'all') || strcmp(option.inputs,'static')) && ~isempty(obj.xStaticInputFunc{i})
        for ii = 1 : length(obj.xStaticInputFunc{i})
            y(ii) = obj.theta(paraRange(1));
            temp =char(obj.xStaticInputFunc{i}{ii});
            cat{ii} = ['$' temp(5:end) '$'];
            paraRange = paraRange + 1;
            x(ii) = ii;
        end
        plot(x,y,'x','MarkerSize',10);
        xlim([0,ii+1]);
        xticks(x);
        xticklabels(cat);
    end
end




end

