function obj = updateGlobalOffset(obj,predOutput)
%UPDATEGLOBALOFFSET Summary of this function goes here
%   Detailed explanation goes here

% calc difference between output and predicted output(in normed range [0 1])
error = obj.currentOutput - obj.normOutput(predOutput);

% update global offset with error and adaption speed
obj.globalOffset = obj.globalOffset + error * obj.AdaptOptions.offsetAdaptionSpeed;



end

