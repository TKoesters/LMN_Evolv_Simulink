function plotAdaptionStatusOverTime(obj,adaptionStatus)
%PLOTADAPTIONSTATUSOVERTIME Summary of this function goes here
%   Detailed explanation goes here

% -------------------------------------------------------------------------
% information conatined in adaptionsStatus
%
% 1st dimension: information to plot (e.g. Neff or regAdaption)
% 2nd dimension: number of lm
% 3rd dimension: input dimension (number of inputs) --> not used for every
%                property. E.g. N_eff or forgetting, but containd in RegAdaption and traceMKReg
% 4th dimension: time (N)
% -------------------------------------------------------------------------

% get interal stored data if no data were submitted externally 
if nargin==1
    if isempty(obj.history.adaptionStatus)
        error('No data were submitted nor data were stored in obj');
    else
        adaptionStatus = obj.history.adaptionStatus;
    end
end

% calc dimension of data
nSettings = size(adaptionStatus,3);

figure;
information2plot = {'Neff','regAdaption','forgetting','trace Reg'};

% iterate through all information
for i = 1 : length(information2plot)
    nexttile;
    % iterate through all local models 
    for ii = 1 : obj.getNumberOfLocalModels  
        hold on;
        switch information2plot{i}
            case {'Neff','forgetting'}
                if obj.dimIn == 1
                    plot(squeeze(adaptionStatus(i,ii,:)));
                else
                    plot(squeeze(adaptionStatus(i,ii,1,:)));
                end
            case {'regAdaption','trace Reg'}
                if obj.dimIn == 1
                    plot(squeeze(adaptionStatus(i,ii,:))');
                else
                    plot(squeeze(adaptionStatus(i,ii,:,:))');
                end
        end
        ylabel(information2plot{i});
        legendEntry{ii} = ['LM$_{' num2str(ii) '}$'];
    end
end
legend(legendEntry);

end

