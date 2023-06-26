function outputNormed = normOutput(obj,output,useOffset)
%NORMOUTPUT Summary of this function goes here
%   Detailed explanation goes here
    
    if nargin==2
        useOffset = true;
    end

    if ~isempty(obj.outputNonlinearity)
        output = obj.outputNonlinearity(output);
    end
    
    outputNormed = normData(output,obj.outputRange);

    % if global offset is active: correct normed output with offset
    if obj.globalOffsetFlag && useOffset
        outputNormed = outputNormed - obj.globalOffset;
    end
    
end

function normedData = normData(u,range)
    normedData = (u-range(1))./abs(range(2)-range(1));
end