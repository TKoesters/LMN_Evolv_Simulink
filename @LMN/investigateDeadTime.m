function [resultsDeadTime,obj] = investigateDeadTime(obj,inputs2investigate,deadTimeRanges)
%INVESTIGATEDEADTIME Summary of this function goes here
%   Detailed explanation goes here

% get number of inputs 2 investigate
number2investigate = length(inputs2investigate);


% create grid with all possible dead times to investigate
deadTimeRangeSamples = cell(number2investigate,1);
for i = 1 : number2investigate
    deadTimeRangeSamples{i} = (deadTimeRanges(i,1) : deadTimeRanges(i,2))';
end

dimensionLength = deadTimeRanges(:,2) - deadTimeRanges(:,1) +  1;
N = prod(dimensionLength);

possibleDeadTimes = zeros(N,number2investigate);

grid = cell(number2investigate,1);
[grid{:}] = ndgrid(deadTimeRangeSamples{:});

% enroll grid to numbe2investigate x N matrix
for i = 1 : number2investigate
    possibleDeadTimes(:,i) = reshape(grid{i},[],1);
end

% run over every possebility
trainError = nan(N,1);
testError = nan(N,1);
numberLMs = nan(N,1);

parfor i = 1 : N
    
    objTemp = obj;
    
    % set current deadtime
    for ii = 1 : number2investigate
        input = inputs2investigate(ii);
        objTemp.xDeadTimes{input} = possibleDeadTimes(i,ii);
        objTemp.zDeadTimes{input} = possibleDeadTimes(i,ii);
    end
    
    % run training algorithm
    objTemp = objTemp.trainLOLIMOT;
    
    trainError(i) = objTemp.calcTrainingError; 
    testError(i) = objTemp.calcTestError;
    numberLMs(i) = objTemp.getNumberOfLocalModels;
    
%     if i ==1
%         bestLMN = objTemp;
%     elseif trainError(i) == min(trainError)
%         bestLMN = objTemp;
%     end
end

% find best lmn
[minError,minErrorIndex] = min(trainError);
bestLMN = obj;
for ii = 1 : number2investigate
    input = inputs2investigate(ii);
    bestLMN.xDeadTimes{input} = possibleDeadTimes(minErrorIndex,ii);
    bestLMN.zDeadTimes{input} = possibleDeadTimes(minErrorIndex,ii);
end
bestLMN = bestLMN.trainLOLIMOT;


% prepare output
resultsDeadTime.trainError = trainError;
resultsDeadTime.testError = testError;
resultsDeadTime.possibleDeadTimes = possibleDeadTimes;
resultsDeadTime.inputs2investigate = inputs2investigate;
resultsDeadTime.numberLocalModels = numberLMs;
resultsDeadTime.bestLMN = bestLMN;

end

