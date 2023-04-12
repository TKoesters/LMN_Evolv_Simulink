function plotPartition(obj,zDimToPlot,D3Flag)
%PLOTPARTITION Summary of this function goes here
%   Detailed explanation goes here

if nargin == 2
    D3Flag = false;
end

switch length(zDimToPlot)
    case 1
              
    case 2
        for i = 1 : obj.getNumberOfLocalModels
            center = obj.localModels{i}.validityFunction.center;
            variance = obj.localModels{i}.validityFunction.variance;

            % add variance and center for empty models
%             center(~cellfun(@isempty,obj.zStaticInputFunc)) = center;
%             center(cellfun(@isempty,obj.zStaticInputFunc)) = 0.5;
%             variance(~cellfun(@isempty,obj.zStaticInputFunc)) = variance;
%             variance(cellfun(@isempty,obj.zStaticInputFunc)) = 0.5;
            
            center = reshape(center,length(center),1);
            variance = reshape(variance,length(variance),1);

            if D3Flag
                center = obj.reNormInputs(center',zDimToPlot);
                variance = obj.reNormInputs(variance',zDimToPlot)-obj.inputRanges(:,1)';
                
                % plot Center
                plot3(center(zDimToPlot(1)),center(zDimToPlot(2)),0,'x');

                hold on;

                % plot Variance
                plotEllipse3(center(zDimToPlot),variance(zDimToPlot));
                
            else
                % plot Center
                plot(center(zDimToPlot(1)),center(zDimToPlot(2)),'x');

                hold on;

                % plot Variance
                plotEllipse(center(zDimToPlot),variance(zDimToPlot));
                axis equal;
    
                xlim([0 1]);
                ylim([0 1]);
                
            end
            xlabel(['$z_' num2str(zDimToPlot(1)) '$']);
            ylabel(['$z_' num2str(zDimToPlot(2)) '$']);
        end
    otherwise
        error('ERROR: no valid dimension were chosen to plot the partition');
end




end



function plotEllipse(center,variance)
    
    t = linspace(0,2*pi,50);

    % calc x coordinate
    x = variance(1) * cos(t) + center(1);
    
    % calc y coordinate
    y = variance(2) * sin(t) + center(2);
    
    plot(x,y);


end

function plotEllipse3(center,variance)
    
    t = linspace(0,2*pi,50);

    % calc x coordinate
    x = variance(1) * cos(t) + center(1);
    
    % calc y coordinate
    y = variance(2) * sin(t) + center(2);
    
    plot3(x,y,zeros(size(y)));


end