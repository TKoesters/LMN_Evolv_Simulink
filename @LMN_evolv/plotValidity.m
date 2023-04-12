function [] = plotValidity(obj,dimensions,AP,LMs)
%PLOTVALIDITY Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    dimensions = [];
end

% iterate through all local models
legendEntries= {};

AP = ones(1,obj.dimIn)*0.5;

for i=1:length(obj.localModels)
    obj.localModels{i}.plotValidity(dimensions,AP);
    hold on;
    legendEntries{i} =['$LM_' num2str(i) '$']; 
end

legend(legendEntries);



end

