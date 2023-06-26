function obj = updateGlobalOffset(obj,predOutput,output)
%UPDATEGLOBALOFFSET Summary of this function goes here
%   Detailed explanation goes here

% calc difference between output and predicted output(in normed range [0 1])
error = obj.normOutput(output - predOutput,false);

% update global offset with error and adaption speed
obj.globalOffset = obj.globalOffset + error * obj.AdaptOptions.offsetAdaptionSpeed;



end

