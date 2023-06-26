function outputNormed = normOutput(obj,output,useGlobal)
%NORMOUTPUT Summary of this function goes here
%   Detailed explanation goes here
    
    if nargin==2
        useGlobal = true;
    end

    if ~isempty(obj.outputNonlinearity)
        output = obj.outputNonlinearity(output);
    end
    
    outputNormed = normData(output,obj.outputRange);

    % order of offset and gain
    % y_hat = f(x) * gain + offset
    % --> first substract offset 
    % --> second calc gain
    
    % if global offset is active: correct normed output with offset
    if obj.globalOffsetFlag && useGlobal
        outputNormed = outputNormed - obj.globalOffset;
    end
    
    % if global gain is active: correct normed output with offset
    if obj.globalGainFlag && useGlobal
        outputNormed = outputNormed / obj.globalGain;
    end
    
end

function normedData = normData(u,range)
    normedData = (u-range(1))./abs(range(2)-range(1));
end