function [Z,X,Y] = plotStaticModel(obj,inputs2Plot,AP,plotPartitionFlag)
%PLOTSTATICMODEL Summary of this function goes here
%   Detailed explanation goes here

if nargin == 2 
    AP = ((obj.inputRanges(:,1) + obj.inputRanges(:,2))./2)';
    plotPartitionFlag = false;
elseif nargin==3
    plotPartitionFlag = false;
elseif isempty(AP)
    AP = ((obj.inputRanges(:,1) + obj.inputRanges(:,2))./2)';
end
    
% set plot flag
obj.plotFlag = true;

% check if static model was obj function was called from
if ~obj.staticModelFlag
    obj = obj.getStaticModel;
end

switch length(inputs2Plot)
    
    case 1
        resolution = 50;
        input2Plot = linspace(obj.inputRanges(inputs2Plot,1),obj.inputRanges(inputs2Plot,2),resolution);
        Inputs = repmat(AP,resolution,1);
        Inputs(:,inputs2Plot) = input2Plot';
        
        if nargout>0
            Z = obj.calcModelOutput(Inputs);
            X = input2Plot;
            Y = [];
        else
            plot(input2Plot,obj.calcModelOutput(Inputs));
            xlabel(['$u_' num2str(inputs2Plot(1)) '$']);
            ylabel('$\hat y$');
        end

        
    case 2
        resolution = 50;
        input2Plot1 = linspace(obj.inputRanges(inputs2Plot(1),1),obj.inputRanges(inputs2Plot(1),2),resolution);
        input2Plot2 = linspace(obj.inputRanges(inputs2Plot(2),1),obj.inputRanges(inputs2Plot(2),2),resolution);
        [u1,u2] = meshgrid(input2Plot1,input2Plot2);
        Inputs = repmat(AP,resolution^2,1);
        Inputs(:,inputs2Plot(1)) = reshape(u1,[],1);
        Inputs(:,inputs2Plot(2)) = reshape(u2,[],1);
        outputs = obj.calcModelOutput(Inputs);
        
        if nargout>0
            Z = reshape(outputs,resolution,resolution);
            X = u1;
            Y = u2;
        else
            surf(u1,u2,reshape(outputs,resolution,resolution));
            xlabel(['$u_' num2str(inputs2Plot(1)) '$']);
            ylabel(['$u_' num2str(inputs2Plot(2)) '$']);
            zlabel('$\hat y$');
            if plotPartitionFlag
                hold on;
                obj.plotPartition(inputs2Plot,true);
                hold off;
            end
        end
        
    otherwise
        error('No appropriate number of inputs2Plot were given');
end



end

