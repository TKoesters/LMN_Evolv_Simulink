function data = showAdaptionStatus(obj,information2plot,dimIn)
% showAdaptionStatus


% -------------------------------------------------------------------------
% information conatined in adaptionsStatus
%
% 1st dimension: information to plot (e.g. Neff or regAdaption)
% 2nd dimension: number of lm
% 3rd dimension: input dimension (number of inputs) --> not used for every
%                property. E.g. N_eff or forgetting, but containd in RegAdaption and traceMKReg
%
% -------------------------------------------------------------------------

if nargin==1
    information2plot = obj.AdaptOptions.information2plot;
    dimIn = obj.dimIn;
elseif nargin==2
    dimIn = obj.dimIn;
end

data = zeros(length(information2plot),obj.getNumberOfLocalModels,dimIn);
% create only figure if no output is given
if nargout==0
    figure;
end

% iterate through all information
for i = 1 : length(information2plot)

    value = zeros(obj.getNumberOfLocalModels,dimIn);

    % iterate through all local models 
    for ii = 1 : obj.getNumberOfLocalModels
        switch information2plot{i}
            case 'Neff'
                value(ii,1) = obj.localModels{ii}.N_eff;

            case 'regAdaption'
                value(ii,1:dimIn) = obj.localModels{ii}.RegAdaption';

            case 'forgetting'
                if isempty(obj.localModels{ii}.forgetting)
                    value(ii,1) = 1;
                else
                    value(ii,1) = obj.localModels{ii}.forgetting;
                end
            case 'trace Reg'
                value(ii,1: dimIn) = obj.localModels{ii}.traceMkReg;

        end

    end
    
    data(i,:,:) = value;

    if nargout==0
        nexttile;
        bar(1:obj.getNumberOfLocalModels,value);
        xlabel('LM')
        ylabel(information2plot{i});
    end
end


end