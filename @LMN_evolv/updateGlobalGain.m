function obj = updateGlobalGain(obj,predOutput,output)
%UPDATEGLOBALOFFSET Summary of this function goes here
%   Detailed explanation goes here

% calc difference between output and predicted output(in normed range [0 1])
error = obj.normOutput(output,false) - obj.normOutput(predOutput,false);

% update global offset with error and adaption speed
obj.globalGain = obj.globalGain + error * obj.normOutput(predOutput,false) * obj.AdaptOptions.gainAdaptionSpeed;

end

