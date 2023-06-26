function output = reNormOutput(obj,normedOutput)
%RENORMOUTPUT Summary of this function goes here
%   Detailed explanation goes here

% order of offset and gain
% y_hat = f(x) * gain + offset
% --> first calc gain
% --> second add offset

% if global gain is active: correct normed output with gain
if obj.globalGainFlag
    normedOutput = normedOutput * obj.globalGain;
end

% if global offset is active: correct normed output with offset
if obj.globalOffsetFlag
    normedOutput = normedOutput + obj.globalOffset;
end

output = reNormData(normedOutput,obj.outputRange);

if ~isempty(obj.outputNonlinearity)
    output = obj.outputInversNonlinearity(output);
end

end

function u = reNormData(uNormed,range)
    u = (uNormed .* abs(range(2)-range(1))) + range(1);
end

