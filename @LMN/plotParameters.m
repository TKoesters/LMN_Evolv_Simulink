function plotParameters(obj)
%PLOTPARAMETERS Summary of this function goes here
%   Detailed explanation goes here

% create figure setupt
f1 = figure;   % offset
f2 = figure;   % dynamic imp
for i = 1 : obj.dimIn
    axesHandleImp{i} = nexttile;
end
f22 = figure;  % dynamic step
for i = 1 : obj.dimIn
    axesHandleStep{i} = nexttile;
end
f3 = figure;   % static

% iterate through all local models
legendEntry = cell(1,obj.getNumberOfLocalModels);
for i = 1 : obj.getNumberOfLocalModels
   
    legendEntry{i} = ['LM$_{' num2str(i) '}$'];
    
    % offset 
    figure(f1);
    options.inputs = 'offset';
    obj.localModels{i}.plotParameter(options);
    hold on;
    
    % dynamic
    figure(f2);
    options.inputs = 'dynamic';
    options.Dyn = 'imp';
    obj.localModels{i}.plotParameter(options,axesHandleImp);
    hold on;
    
    figure(f22);
    options.inputs = 'dynamic';
    options.Dyn = 'step';
    obj.localModels{i}.plotParameter(options,axesHandleStep);
    hold on;
    
    % static
    figure(f3);
    options.inputs = 'static';
    obj.localModels{i}.plotParameter(options);
    hold on;
end

% add legend
%offset 
figure(f1);
legend(legendEntry,'Interpreter','latex');

%dynamic 
figure(f2);
legend(legendEntry);

%static 
figure(f3);
legend(legendEntry);

end

