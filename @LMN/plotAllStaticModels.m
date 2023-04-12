function plotAllStaticModels(obj,AP)
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
nInputs = obj.dimIn - 1; 

% create nInputs x nInputs subplots
for row = 1 : nInputs
    for coll = 1 : nInputs
        if coll <= row
            % calc number of subplot 
            nSubplot = (row-1) * nInputs + coll;
            subplot(nInputs,nInputs,nSubplot)
            obj.plotStaticModel([coll,row+1],AP);
%             xlabel('');
%             ylabel('');
%             zlabel('');
            
%             % labels
%             if coll == 1
%                 [~,yLabel,~] = obj.setAxisLabels([coll,row+1]);
%                 ylabel(yLabel);
%             end
%             
%             if row == nInputs
%                 [xLabel,~,~] = obj.setAxisLabels([coll,row+1]);
%                 xlabel(xLabel);
%             end
            
            if coll==1 && row == 1
                title(obj.info.outputDescription);
            end
        end
    end
end




end

