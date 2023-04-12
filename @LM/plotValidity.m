function [] = plotValidity(obj,inputDimension,AP)
%PLOTVALIDITY Summary of this function goes here
%   Detailed explanation goes here

    switch nargin
        case 1
            if length(obj.validityFunction.center) > 2
                warning('WARNING: no input dimension were submitted. 1 and 2 are automatically chosen.');
                inputDimension = [1;2];
            elseif  length(obj.validityFunction.center) == 1
                inputDimension = [1];
            else
                inputDimension = [1;2];
            end

        case 2
            if length(inputDimension) > length(obj.validityFunction.center)
                warning(['WARNING: more dimensions to plot than input dimensions were submitted.' ...
                    'only the first ' num2str(obj.validityFunction.nInputs) ' dimensions are used']);
                inputDimension = inputDimension(1:obj.validityFunction.nInputs);
            end
    end
    
    
    
    % check how much dimensions the inputs are
    switch length(inputDimension)
        case 1
            plot1D(obj,inputDimension,AP);

        case 2
            plot2D(obj,inputDimension,AP);

    end
end

function [] = plot1D(obj,inputDimension,AP)

    resolution = 100;
    input = linspace(0,1,resolution);
    inputVector = repmat(AP,resolution,1);
    inputVector(:,inputDimension) = input;
%     y = NaN(size(input));
%     for i=1:resolution
%         inputVector(inputDimension) = input(i);
%         y(i) = obj.validityFunction.calcValidity(inputVector);
%     end
    y = obj.validityFunction.calcValidity(inputVector);
    plot(input,y);
    xlabel(['$x_' num2str(inputDimension) '$']);
    ylabel('$y$');
end


function [] = plot2D(obj,inputDimension,AP)

    resolution = 50;
    input = linspace(0,1,resolution);
    [u1,u2] = meshgrid(input,input);
    inputVector = repmat(AP,resolution^2,1);
    inputVector(:,inputDimension) = [reshape(u1,[],1),reshape(u2,[],1)];
%     y = NaN(size(u1));
%     for i=1:resolution
%         for ii=1:resolution
%             inputVector(inputDimension) = [u1(i,ii);u2(i,ii)];
%             y(i,ii) = obj.validityFunction.calcValidity([u1(i,ii);u2(i,ii)]);
%         end
%     end
    y = obj.validityFunction.calcValidity(inputVector);

    surf(u1,u2,reshape(y,resolution,resolution));

    xlabel(['$x_' num2str(inputDimension(1)) '$']);
    ylabel(['$x_' num2str(inputDimension(2)) '$']);
    zlabel('$y$');
end