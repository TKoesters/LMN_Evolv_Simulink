function [obj, priorOutput] = updateLMN(obj,input,output,updateFlagLM,updateFlagOffset)
%UPDATELMN Summary of this function goes here
%   Detailed explanation goes here

if nargin<4
    updateFlagLM = true;
    updateFlagOffset = false;
elseif nargin==4
    updateFlagOffset = false;
end


% check if adaption flag is already set, if not initialize for adaption
if ~obj.adaptionFlag
    obj = obj.initializeLMNforAdaption;
end

% update Regressors and Datapuffer
obj = obj.updateRegressors(input,output);

% calculate predicted output
[~,priorOutput] = obj.calcCurrentModelOutput;

% calc global error
obj.globalError = obj.globalError * (obj.AdaptOptions.errorFilter) + (1-obj.AdaptOptions.errorFilter) * (obj.normOutput(output) - obj.normOutput(priorOutput));

% update local Models
if updateFlagLM
    obj = obj.updateLocalModels(obj.globalError);
end

% update offset
if updateFlagOffset
    obj = obj.updateGlobalOffset(priorOutput);
end

% if history data storing switched on store current adaption status
if obj.AdaptOptions.dataCollection
    if isempty(obj.history.adaptionStatus)
        timeIndex = 0;
    else
        timeIndex = size(obj.history.adaptionStatus,4);
    end
    obj.history.adaptionStatus(:,:,:,timeIndex + 1) =  obj.showAdaptionStatus;
end
% HIER MORGEN WEITER MACHEN !!!! 


end

