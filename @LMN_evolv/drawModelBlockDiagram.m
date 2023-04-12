function drawModelBlockDiagram(obj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% if model wasn't checked yet do so
if ~obj.dimensionCheck
   obj = obj.checkDimension;
end

% options to change
thickLineWidht = 4;
thinLineWidht = 1.5;
thickHeadWidht = 12;
xStart = 3;
xEnd = 5;
faktorDrawing = 1;
boxWidht = 1.3;
boxHightFaktor = 0.8;
% get number of inputs 
numberInputs = obj.dimIn;

% dyn input dimensions
numberInputsZ_dyn = sum(~cellfun(@isempty,obj.zDynInputDelay));
numberInputsX_dyn = sum(~cellfun(@isempty,obj.xDynInputDelay));

% static input dimensions
numberInputsZ_static = 0;
numberInputsX_static = 0;

set(groot,'defaultLineLineWidth',1)

for i = 1 : obj.dimIn
    if ~isempty(obj.zStaticInputFunc{i})
        numberInputsZ_static = numberInputsZ_static + sum(~cellfun(@isempty,obj.zStaticInputFunc{i}));
    end
    if ~isempty(obj.xStaticInputFunc{i})
        numberInputsX_static = numberInputsX_static + sum(~cellfun(@isempty,obj.xStaticInputFunc{i}));
    end
end

% overall number of input lines to lmn
numberInputsCompleteZ = numberInputsZ_dyn + numberInputsZ_static;
numberInputsCompleteX = numberInputsX_dyn + numberInputsX_static;
numberInputsComplete = numberInputsZ_dyn + numberInputsX_dyn + numberInputsZ_static + numberInputsX_static;

% get number of filters
numberFilterZ = 0;
numberFilterX = 0;
for i = 1 : obj.dimIn
    if ~isempty(obj.zSpaceInputFilterPoles)
        numberFilterZ = numberFilterZ + ~isempty(obj.zSpaceInputFilterPoles{i});
    end
    if ~isempty(obj.xSpaceInputFilterPoles{i})
        numberFilterX = numberFilterX + ~isempty(obj.xSpaceInputFilterPoles{i});
    end
end

% get number of filters
numberTtZ = 0;
numberTtrX = 0;
for i = 1 : obj.dimIn
    if ~isempty(obj.zDeadTimes{i})
        numberTtZ = numberTtZ + ~isempty(obj.zDeadTimes{i});
    end
    if ~isempty(obj.xDeadTimes{i})
        numberTtrX = numberTtrX + ~isempty(obj.xDeadTimes{i});
    end
end

% create rectangle with enough space for all inputs (5 *
% numberInputsComplete)
figure
plot(6,2,'.','Color',[1,1,1]);
currentAxes = gca;
if obj.staticModelFlag
    StringLMN{1} = 'static LMN';
else
    StringLMN{1} = 'dynamic LMN';
end
StringLMN{2} = [num2str(obj.dimIn) ' Inputs;  1 Output'];
StringLMN{3} = [num2str(obj.getNumberOfLocalModels) ' LMs'];
StringLMN{4} = '';
StringLMN{5} = ['Reg: ' obj.RegOptions.method];

stringLambda = '';
stringPole = '';
for i = 1 : obj.dimIn
    if isscalar(obj.RegOptions.lambda)
        stringLambda =['$\lambda = ' num2str(obj.RegOptions.lambda) '$'];
    else
        if mod(i-1,2)==0 && i~=1
            stringLambda = [stringLambda, newline];
        end
        stringLambda =[stringLambda '$\lambda_' num2str(i) ' = ' num2str(obj.RegOptions.lambda(i)) '$  '];
        
    end
    if isscalar(obj.RegOptions.a)
        stringPole = ['$a = ' num2str(obj.RegOptions.a) '$'];
    else
        stringPole = [stringPole '$a_' num2str(i) ' = ' num2str(obj.RegOptions.a(i)) '$  '];
    end
end
StringLMN{6} = stringLambda;
StringLMN{7} = stringPole;

lmnBox  = annotation('textbox','Interpreter','latex','String',StringLMN);
lmnBox.Parent =  currentAxes;
lmnBox.Position = [3, 0, 4, faktorDrawing*numberInputsComplete];
lmnBox.BackgroundColor = [1 1 1];
lmnBox.HorizontalAlignment = 'center';
lmnBox.VerticalAlignment = 'middle';
lmnBox.FontSize = 15;

hold on;
currentAxes = gca;
% find positions for x-Space 
xSpaceDiff = faktorDrawing*numberInputsComplete/2/(numberInputsCompleteX+1);
xSpace = (numberInputsCompleteX:-1:1) * xSpaceDiff + faktorDrawing*numberInputsComplete/2;

% find positions for z-Space 
zSpaceDiff = faktorDrawing*numberInputsComplete/2/(numberInputsCompleteZ+1);
zSpace = (numberInputsCompleteZ:-1:1)  * zSpaceDiff;


boxHight = boxHightFaktor * min(zSpaceDiff,xSpaceDiff);


% test for position
% plot(xStart*ones(length(xSpace)),xSpace,'x');
% plot(xStart*ones(length(zSpace)),zSpace,'o');

% draw boxes for every input & conect boxes to lmn
xBoxStart = 1;
xBoxEnd = xBoxStart + boxWidht;
% for i = [xSpace,zSpace]
%     %rectangle('Position',[xBoxStart i-1 xBoxEnd-xBoxStart 2]);  
%     ha = annotation('arrow');
%     ha.Parent = currentAxes;  % associate annotation with current axes
%     % now you can use data units
%     ha.X = [xBoxEnd xStart];
%     ha.Y = [i i];
%     ha.LineWidth = thickLineWidht;
%     ha.HeadWidth = thickHeadWidht;
% end

% find out if daedTimes are used
xStartInputs = 0;
if (numberTtrX + numberTtZ) > 0
    xStartInputs = -2;     
end

% find out if filters are used
if (numberFilterX + numberFilterZ) > 0
    xStartInputs = xStartInputs-2;     
end

% iterate through all inputs and connect with boxes 
% also insert boxes for daed time and filter when needed
posInputs =  faktorDrawing*numberInputsComplete - ((faktorDrawing*numberInputsComplete / (obj.dimIn+1)) * (1:obj.dimIn));
currentIndexX = 1;
currentIndexZ = 1;


endTtFilterX = nan(obj.dimIn,1);
endTtFilterY = nan(obj.dimIn,1);
endFilterSet = false(obj.dimIn,1);

% x-Space
for i = 1 : obj.dimIn   
    % x-Space dyn
    if ~isempty(obj.xDynInputDelay{i})
        
        if ~endFilterSet(i)
            plotArrow([xStartInputs-0.5,xStartInputs,xStartInputs,xBoxStart],[posInputs(i),xSpace(currentIndexX),xSpace(currentIndexX),xSpace(currentIndexX)],currentAxes,thinLineWidht,thickHeadWidht);

            newBoxesStartPosition = xStartInputs+1;
            % add deadtime when needed
            if ~isempty(obj.xDeadTimes{i})
                TtBox = annotation('textbox','interpreter','latex','String',['$T_t=' num2str(obj.xDeadTimes{i}) ,'$']);
                TtBox.Parent =  currentAxes;
                TtBox.Position = [newBoxesStartPosition,xSpace(currentIndexX)-boxHight/2, boxWidht ,boxHight];
                TtBox.BackgroundColor = [1 1 1];
                TtBox.HorizontalAlignment = 'center';
                TtBox.VerticalAlignment = 'middle';
                plotArrowAtBox(TtBox,thinLineWidht,thickHeadWidht);    
            end

            newBoxesStartPosition  = newBoxesStartPosition + 1;
            % add filter when needed
            if ~isempty(obj.xSpaceInputFilterPoles{i})
                FilterBox = annotation('textbox','interpreter','latex','String',['$p =' num2str(obj.xSpaceInputFilterPoles{i}) ,'$']);
                FilterBox.Parent =  currentAxes;
                FilterBox.Position = [newBoxesStartPosition,xSpace(currentIndexX)-boxHight/2, boxWidht ,boxHight];
                FilterBox.BackgroundColor = [1 1 1];
                FilterBox.HorizontalAlignment = 'center';
                FilterBox.VerticalAlignment = 'middle';
                plotArrowAtBox(FilterBox,thinLineWidht,thickHeadWidht);    
            end

            endTtFilterX(i) = xBoxStart-0.5;
            endTtFilterY(i) = xSpace(currentIndexX);
            endFilterSet(i) = true;
        else
            plotDoubleArrow([endTtFilterX(i),endTtFilterX(i),xBoxStart],[endTtFilterY(i),xSpace(currentIndexX),xSpace(currentIndexX)],currentAxes,thinLineWidht,thickHeadWidht);
        end
        
        dynBox = annotation('textbox','interpreter','latex','String',['d(1:' num2str(obj.xDynInputDelay{i}) ,')']);
        dynBox.Parent = currentAxes;
        dynBox.Position = [xBoxStart, xSpace(currentIndexX)-boxHight/2 , boxWidht ,boxHight];
        dynBox.HorizontalAlignment = 'center';
        dynBox.VerticalAlignment = 'middle';
        dynBox.BackgroundColor = [1 1 1];        
        
        ha = annotation('arrow');
        ha.Parent = currentAxes;  % associate annotation with current axes
        % now you can use data units
        ha.X = [xBoxEnd xStart];
        ha.Y = [xSpace(currentIndexX) xSpace(currentIndexX)];
        ha.LineWidth = thickLineWidht;
        ha.HeadWidth = thickHeadWidht;
        
        currentIndexX = currentIndexX + 1;

    end
    
    % x-Space static
    for ii = 1:length(obj.xStaticInputFunc{i})
        if ~endFilterSet(i)
            plotArrow([xStartInputs-0.5,xStartInputs,xStartInputs,xBoxStart],[posInputs(i),xSpace(currentIndexX),xSpace(currentIndexX),xSpace(currentIndexX)],currentAxes,thinLineWidht,thickHeadWidht);

            newBoxesStartPosition = xStartInputs+1;
            % add deadtime when needed
            if ~isempty(obj.xDeadTimes{i})
                TtBox = annotation('textbox','interpreter','latex','String',['$T_t=' num2str(obj.xDeadTimes{i}) ,'$']);
                TtBox.Parent =  currentAxes;
                TtBox.Position = [newBoxesStartPosition,xSpace(currentIndexX)-boxHight/2, boxWidht ,boxHight];
                TtBox.BackgroundColor = [1 1 1];
                TtBox.HorizontalAlignment = 'center';
                TtBox.VerticalAlignment = 'middle';
                plotArrowAtBox(TtBox,thinLineWidht,thickHeadWidht);
            end

            newBoxesStartPosition  = newBoxesStartPosition + 2;
            % add filter when needed
            if ~isempty(obj.xSpaceInputFilterPoles{i})
                FilterBox = annotation('textbox','interpreter','latex','String',['$p =' num2str(obj.xSpaceInputFilterPoles{i}) ,'$']);
                FilterBox.Parent =  currentAxes;
                FilterBox.Position = [newBoxesStartPosition,xSpace(currentIndexX)-boxHight/2, boxWidht ,boxHight];
                FilterBox.BackgroundColor = [1 1 1];
                FilterBox.HorizontalAlignment = 'center';
                FilterBox.VerticalAlignment = 'middle';
                plotArrowAtBox(FilterBox,thinLineWidht,thickHeadWidht);
            end

            endTtFilterX(i) = xBoxStart-0.5;
            endTtFilterY(i) = xSpace(currentIndexX);
            endFilterSet(i) = true;
            
        else
            plotDoubleArrow([endTtFilterX(i),endTtFilterX(i),xBoxStart],[endTtFilterY(i),xSpace(currentIndexX),xSpace(currentIndexX)],currentAxes,thinLineWidht,thickHeadWidht);
        end
        funcStr = func2str(obj.xStaticInputFunc{i}{ii});
        staticBox = annotation('textbox','interpreter','latex','String',['$f(u)=' funcStr(5:end) '$']);
        staticBox.Parent = currentAxes;
        staticBox.Position = [xBoxStart, xSpace(currentIndexX)-boxHight/2, boxWidht ,boxHight];
        staticBox.HorizontalAlignment = 'center';
        staticBox.VerticalAlignment = 'middle';
        staticBox.BackgroundColor = [1 1 1];

        %('Position',[xBoxStart i-1 xBoxEnd-xBoxStart 2]);  
        
        ha = annotation('arrow');
        ha.Parent = currentAxes;  % associate annotation with current axes
        % now you can use data units
        ha.X = [xBoxEnd xStart];
        ha.Y = [xSpace(currentIndexX) xSpace(currentIndexX)];
        ha.LineWidth = thinLineWidht;
        ha.HeadWidth = thickHeadWidht;
        
        
        currentIndexX = currentIndexX + 1;
    end
    
end


endTtFilterX = nan(obj.dimIn,1);
endTtFilterY = nan(obj.dimIn,1);
endFilterSet = false(obj.dimIn,1);
% z-Space
for i = 1 : obj.dimIn   
    
    if ~isempty(obj.zDynInputDelay{i})
        
        if ~endFilterSet(i)
            plotArrow([xStartInputs-0.5,xStartInputs,xStartInputs,xBoxStart],[posInputs(i),zSpace(currentIndexZ),zSpace(currentIndexZ),zSpace(currentIndexZ)],currentAxes,thinLineWidht,thickHeadWidht);

            newBoxesStartPosition = xStartInputs+1;
            % add deadtime when needed
            if ~isempty(obj.zDeadTimes{i})
                TtBox = annotation('textbox','interpreter','latex','String',['$T_t=' num2str(obj.zDeadTimes{i}) ,'$']);
                TtBox.Parent =  currentAxes;
                TtBox.Position = [newBoxesStartPosition,zSpace(currentIndexZ)-boxHight/2, boxWidht ,boxHight];
                TtBox.BackgroundColor = [1 1 1];
                TtBox.HorizontalAlignment = 'center';
                TtBox.VerticalAlignment = 'middle';
                plotArrowAtBox(TtBox,thinLineWidht,thickHeadWidht);
            end

            newBoxesStartPosition  = newBoxesStartPosition + 1;
            % add filter when needed
            if ~isempty(obj.zSpaceInputFilterPoles{i})
                FilterBox = annotation('textbox','interpreter','latex','String',['$p =' num2str(obj.zSpaceInputFilterPoles{i}) ,'$']);
                FilterBox.Parent =  currentAxes;
                FilterBox.Position = [newBoxesStartPosition,zSpace(currentIndexZ)-boxHight/2, boxWidht ,boxHight];
                FilterBox.BackgroundColor = [1 1 1];
                FilterBox.HorizontalAlignment = 'center';
                FilterBox.VerticalAlignment = 'middle';
                plotArrowAtBox(FilterBox,thinLineWidht,thickHeadWidht);
            end

            endTtFilterX(i) = xBoxStart-0.5;
            endTtFilterY(i) = zSpace(currentIndexZ);
            endFilterSet(i) = true;
            
        else
            plotDoubleArrow([endTtFilterX(i),endTtFilterX(i),xBoxStart],[endTtFilterY(i),zSpace(currentIndexZ),zSpace(currentIndexZ)],currentAxes,thinLineWidht,thickHeadWidht);
        end
        
        dynBox = annotation('textbox','interpreter','latex','String',['d(1:' num2str(obj.zDynInputDelay{i}) ,')']);
        dynBox.Parent = currentAxes;
        dynBox.Position = [xBoxStart, zSpace(currentIndexZ)-boxHight/2, boxWidht ,boxHight];
        dynBox.HorizontalAlignment = 'center';
        dynBox.VerticalAlignment = 'middle';
        dynBox.BackgroundColor = [1 1 1];

        %('Position',[xBoxStart i-1 xBoxEnd-xBoxStart 2]);  
        
        ha = annotation('arrow');
        ha.Parent = currentAxes;  % associate annotation with current axes
        % now you can use data units
        ha.X = [xBoxEnd xStart];
        ha.Y = [zSpace(currentIndexZ) zSpace(currentIndexZ)];
        ha.LineWidth = thickLineWidht;
        ha.HeadWidth = thickHeadWidht;
        
        
        currentIndexZ = currentIndexZ + 1;
            
    end
    
    % z-Space static
    for ii = 1:length(obj.zStaticInputFunc{i})
        if ~endFilterSet(i)
            plotArrow([xStartInputs-0.5,xStartInputs,xStartInputs,xBoxStart],[posInputs(i),zSpace(currentIndexZ),zSpace(currentIndexZ),zSpace(currentIndexZ)],currentAxes,thinLineWidht,thickHeadWidht);

            newBoxesStartPosition = xStartInputs+1;
            % add deadtime when needed
            if ~isempty(obj.xDeadTimes{i})
                TtBox = annotation('textbox','interpreter','latex','String',['$T_t=' num2str(obj.xDeadTimes{i}) ,'$']);
                TtBox.Parent =  currentAxes;
                TtBox.Position = [newBoxesStartPosition,zSpace(currentIndexZ)-boxHight/2, boxWidht ,boxHight];
                TtBox.BackgroundColor = [1 1 1];
                TtBox.HorizontalAlignment = 'center';
                TtBox.VerticalAlignment = 'middle';
                plotArrowAtBox(TtBox,thinLineWidht,thickHeadWidht);
            end

            newBoxesStartPosition  = newBoxesStartPosition + 2;
            % add filter when needed
            if ~isempty(obj.zSpaceInputFilterPoles{i})
                FilterBox = annotation('textbox','interpreter','latex','String',['$p =' num2str(obj.zSpaceInputFilterPoles{i}) ,'$']);
                FilterBox.Parent =  currentAxes;
                FilterBox.Position = [newBoxesStartPosition,zSpace(currentIndexZ)-boxHight/2, boxWidht ,boxHight];
                FilterBox.BackgroundColor = [1 1 1];
                FilterBox.HorizontalAlignment = 'center';
                FilterBox.VerticalAlignment = 'middle';
                plotArrowAtBox(FilterBox,thinLineWidht,thickHeadWidht);

            end

            endTtFilterX(i) = xBoxStart-0.5;
            endTtFilterY(i) = zSpace(currentIndexZ);
            endFilterSet(i) = true;
            
        else
            plotDoubleArrow([endTtFilterX(i),endTtFilterX(i),xBoxStart],[endTtFilterY(i),zSpace(currentIndexZ),zSpace(currentIndexZ)],currentAxes,thinLineWidht,thickHeadWidht);
        end
        funcStr = func2str(obj.zStaticInputFunc{i}{ii});
        staticBox = annotation('textbox','interpreter','latex','String',['$f(u)=' funcStr(5:end) '$']);
        staticBox.Parent = currentAxes;
        staticBox.Position = [xBoxStart, zSpace(currentIndexZ)-boxHight/2, boxWidht ,boxHight];
        staticBox.HorizontalAlignment = 'center';
        staticBox.VerticalAlignment = 'middle';
        staticBox.BackgroundColor = [1 1 1];

        %('Position',[xBoxStart i-1 xBoxEnd-xBoxStart 2]);  
        
        ha = annotation('arrow');
        ha.Parent = currentAxes;  % associate annotation with current axes
        % now you can use data units
        ha.X = [xBoxEnd xStart];
        ha.Y = [zSpace(currentIndexZ) zSpace(currentIndexZ)];
        ha.LineWidth = thinLineWidht;
        ha.HeadWidth = thickHeadWidht;
        
        
        currentIndexZ = currentIndexZ + 1;
    end
    
    
    % add arrows with input names
    if i > length(obj.info.inputDescription)
        obj.info.inputDescription{i} = ['u_' num2str(i)];
    end
    ar = annotation('textarrow','interpreter','latex','String', ['$' obj.info.inputDescription{i} '$']);
    ar.Parent = currentAxes;  % associate annotation with current axes
    % now you can use data units
    ar.X = [xStartInputs-1 xStartInputs-0.5+0.03];
    ar.Y = [posInputs(i) posInputs(i)];
    ar.LineWidth = thinLineWidht;
    ar.HeadWidth = 4;
    ar.HeadLength = 4;
    ar.HeadStyle = 'ellipse';
    ar.FontSize = 15;
end

% plot output Arrow
ar = annotation('arrow');
ar.Parent = currentAxes;  % associate annotation with current axes
% now you can use data units
ar.X = [7 8];
ar.Y = [faktorDrawing*numberInputsComplete/2 faktorDrawing*numberInputsComplete/2];
ar.LineWidth = thinLineWidht;
ar.HeadWidth = thickHeadWidht;

tb = annotation('textbox','interpreter','latex','String', substituteRAW(obj.info.outputDescription));
tb.Parent = currentAxes;
tb.Position = [8.2, faktorDrawing*numberInputsComplete/2-1, 3, 2];
tb.VerticalAlignment = 'middle';
tb.HorizontalAlignment = 'left';
tb.LineStyle = 'none';
tb.FontSize = 15;

% x-Space
tb = annotation('textbox','String','x','interpreter','latex');
tb.Parent = currentAxes;
tb.Position = [3, faktorDrawing*numberInputsComplete/2+xSpaceDiff * 0.5, 0.5, xSpaceDiff*(numberInputsCompleteX)];
tb.VerticalAlignment = 'middle';
tb.HorizontalAlignment = 'center';

% z-Space
tb = annotation('textbox','String','z','interpreter','latex');
tb.Parent = currentAxes;
tb.Position = [3, 0+zSpaceDiff * 0.5, 0.5, zSpaceDiff*(numberInputsCompleteZ)];
tb.VerticalAlignment = 'middle';
tb.HorizontalAlignment = 'center';

axis equal;
axis off;
xlim([-5 10]);
ylim([-1 faktorDrawing*numberInputsComplete+1]);

% reset plot Options to given values
SetPlotOptions;

end


function plotArrow(x,y,currentAxes,lineWidth,headWidth)

    plot(x,y,'color','black','LineWidth',lineWidth);

    ar = annotation('arrow');
    ar.Parent = currentAxes;  % associate annotation with current axes
    % now you can use data units
    ar.X = [x(end-1) x(end)];
    ar.Y = [y(end-1) y(end)];
    ar.LineWidth = lineWidth;
    ar.HeadWidth = headWidth;
end

function plotDoubleArrow(x,y,currentAxes,lineWidth,headWidth)
    plot(x,y,'color','black','LineWidth',lineWidth);

    ar = annotation('arrow');
    ar.Parent = currentAxes;  % associate annotation with current axes
    % now you can use data units
    ar.X = [x(end-1) x(end)];
    ar.Y = [y(end-1) y(end)];
    ar.LineWidth = lineWidth;
    ar.HeadWidth = headWidth;
    
    ar2 = annotation('arrow');
    ar2.Parent = currentAxes;  % associate annotation with current axes
    % now you can use data units
    ar2.X = [x(2) x(1)];
    ar2.Y = [y(2) y(1)+0.03];
    ar2.LineWidth = lineWidth;
    ar2.HeadWidth = 4;
    ar2.HeadLength = 4;

    ar2.HeadStyle = 'ellipse';
%     ar.LineWidth = lineWidth;
%     ar.HeadWidth = headWidth;
end


function plotArrowAtBox(Box,lineWidth,headWidth)
        
    ar = annotation('arrow');
    ar.Parent = Box.Parent;  % associate annotation with current axes
    % now you can use data units
    ar.X = [Box.Position(1) - 0.01, Box.Position(1) - 0.01 ];
    ar.Y = [Box.Position(2)+Box.Position(4)/2, Box.Position(2)+Box.Position(4)/2 ];
    ar.LineWidth = lineWidth;
    ar.HeadWidth = headWidth;
end