function showCenterAndVariances(obj)
%SHOWCENTERANDVARIANCES Summary of this function goes here
%   Detailed explanation goes here

fprintf('Center of local models \n');
for i = 1 : obj.getNumberOfLocalModels
    stringHelp = [];
    for ii = 1 : length(obj.localModels{1}.validityFunction.center)
        stringHelp = [stringHelp '; ' num2str(obj.localModels{i}.validityFunction.center(ii))];
    end
    stringToDisp = ['Center Model %i : ' stringHelp '\n'];
    fprintf(stringToDisp,i);
end

fprintf('\n Variance of local models \n');
for i = 1 : obj.getNumberOfLocalModels
    stringHelp = [];
    for ii = 1 : length(obj.localModels{1}.validityFunction.center)
        stringHelp = [stringHelp '; ' num2str(obj.localModels{i}.validityFunction.variance(ii))];
    end
    stringToDisp = ['Variance Model %i : ' stringHelp '\n'];
    fprintf(stringToDisp,i);
end


end

