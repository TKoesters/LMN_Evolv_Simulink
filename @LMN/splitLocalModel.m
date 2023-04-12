function [obj] = splitLocalModel(obj,numberOfLocalModel,dimension)
%SPLITLOALMODEL Summary of this function goes here
%   Detailed explanation goes here

% get Current split properties of LM
currentVariance = obj.localModels{numberOfLocalModel}.getVariance;
currentCenter = obj.localModels{numberOfLocalModel}.getCenter;
currentSplitCnt = obj.localModels{numberOfLocalModel}.splitCounter;


% create new models after split
newSplitCnt1 = currentSplitCnt;
newSplitCnt1(dimension) = newSplitCnt1(dimension) + 1;
newVariance1 = currentVariance;
newVariance1(dimension) = currentVariance(dimension)/2;
newCenter1 = currentCenter;
newCenter1(dimension) = currentCenter(dimension) - 1/2^(newSplitCnt1(dimension));
obj = obj.insertNewLocalModel(newCenter1,newVariance1,true,newSplitCnt1);

newSplitCnt2 = currentSplitCnt;
newSplitCnt2(dimension) = newSplitCnt2(dimension) + 1;
newVariance2 = currentVariance;
newVariance2(dimension) = currentVariance(dimension)/2;
newCenter2 = currentCenter;
newCenter2(dimension) = currentCenter(dimension) + 1/2^(newSplitCnt2(dimension));
obj = obj.insertNewLocalModel(newCenter2,newVariance2,true,newSplitCnt2);

% delete old model
obj = obj.deleteLocalModel(numberOfLocalModel);


% figure(1)
% obj.plotValidity;

end

