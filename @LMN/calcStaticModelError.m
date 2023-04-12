function staticError = calcStaticModelError(obj,staticModel,errorMeasurement,constraints)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin<3
    errorMeasurement = 'NRMSE';
    constraints = [];
elseif nargin<4
    constraints = [];
end


% create nDim dimensional grid
pointsDimension = 10;
gridPoints = zeros(pointsDimension^obj.dimIn,obj.dimIn);
switch obj.dimIn
    case 1
        gridPoints = linspace(obj.inputRanges(1),obj.inputRanges(2),pointsDimension)';
    
    case 2
        [X,Y] = meshgrid(linspace(obj.inputRanges(1,1),obj.inputRanges(1,2),pointsDimension),linspace(obj.inputRanges(2,1),obj.inputRanges(2,2),pointsDimension));
        gridPoints(:,1) = reshape(X,[],1);
        gridPoints(:,2) = reshape(Y,[],1);

    case 3
        [X1,X2,X3] = ndgrid(linspace(obj.inputRanges(1,1),obj.inputRanges(1,2),pointsDimension),linspace(obj.inputRanges(2,1),obj.inputRanges(2,2),pointsDimension),linspace(obj.inputRanges(3,1),obj.inputRanges(3,2),pointsDimension));
        gridPoints(:,1) = reshape(X1,[],1);
        gridPoints(:,2) = reshape(X2,[],1);
        gridPoints(:,3) = reshape(X3,[],1);
    
    case 4
        [X1,X2,X3,X4] = ndgrid(linspace(obj.inputRanges(1,1),obj.inputRanges(1,2),pointsDimension),linspace(obj.inputRanges(2,1),obj.inputRanges(2,2),pointsDimension),linspace(obj.inputRanges(3,1),obj.inputRanges(3,2),pointsDimension),...
            linspace(obj.inputRanges(4,1),obj.inputRanges(4,2),pointsDimension));
        gridPoints(:,1) = reshape(X1,[],1);
        gridPoints(:,2) = reshape(X2,[],1);
        gridPoints(:,3) = reshape(X3,[],1);
        gridPoints(:,4) = reshape(X4,[],1);
    otherwise
        error('Cases obj.dimIn > 4 not implemented yet');
end

% remove all points violate constraints
if ~isempty(constraints)
    gridPoints = gridPoints(constraints(gridPoints),:);
end

% calc static model output
staticLMN = obj.getStaticModel;
staticOutputLMN = staticLMN.calcModelOutput(gridPoints)';

staticOutputModel = staticModel(gridPoints);

switch errorMeasurement
    case 'NRMSE'
        squaredError = sum((staticOutputLMN-staticOutputModel).^2);
        varMeasurement = sum((staticOutputModel - mean(staticOutputModel)).^2) ;
        staticError =  sqrt(squaredError/varMeasurement);
    case 'MSE'
        staticError = 1/length(staticOutputModel) * sum((staticOutputLMN-staticOutputModel).^2);
    case 'RMSE'
        staticError =  sqrt(sum((staticOutputLMN-staticOutputModel).^2) / length(staticOutputModel));
end

 

end

