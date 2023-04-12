function [obj] = deleteTrainingAndStructure(obj)
%DELETETRAININGANDSTRUCTURE Summary of this function goes here
%   Detailed explanation goes here

% delete all local models 
obj.localModels = {};

% reset flags
obj.dimensionCheck = false;

% delete weighting 
obj.weighting = [];

end

