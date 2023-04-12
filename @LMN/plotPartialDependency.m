function plotPartialDependency(obj,AP)
%PLOTALLSTATICMODELS Summary of this function goes here
%   Detailed explanation goes here

% check if static model was obj function was called from
if ~obj.staticModelFlag
    obj = obj.getStaticModel;
end

if nargin == 1 
    AP = ((obj.inputRanges(:,1) + obj.inputRanges(:,2))./2)';
end

% get number Inputs
nInputs = obj.dimIn; 

% create nInputs x nInputs subplots
for coll = 1 : nInputs
    % calc number of subplot 
    nSubplot = coll;
    subplot(1,nInputs,nSubplot)
    obj.plotStaticModel(coll,AP);
    
    if coll==1 
        title(obj.info.outputDescription);
        ylabel(obj.info.outputDescription);
    else
        ylabel('');
    end
    xlabel(['$' obj.info.inputDescription{coll} '$']);

end


end