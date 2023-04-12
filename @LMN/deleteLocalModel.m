function obj = deleteLocalModel(obj,numberOfLocalModel) 
%DELETELOCALMODEL Summary of this function goes here
%   Detailed explanation goes here

%create vector of remaining local models
vecRemainingLocalModels = true(obj.getNumberOfLocalModels,1);
vecRemainingLocalModels(numberOfLocalModel) = false;

%create new local model cell array
cnt = 0;
newLocalModels = cell(sum(vecRemainingLocalModels),1);
for i = 1 : length(vecRemainingLocalModels)
    if vecRemainingLocalModels(i)
        cnt = cnt + 1;
        newLocalModels{cnt} = obj.localModels{i};
    end
end

%delete local model 
obj.localModels = newLocalModels;

end

