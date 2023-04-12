function [splitDyn,splitStatic,nPosSplits] = getPosSplits(obj)
%GETPOSSPLITS Summary of this function goes here
%   Detailed explanation goes here

    % find possible dimensions of split
    splitDyn = [];
    splitStatic = [];
    cntDyn = 0;
    cntStatic = 0;
    splitDynOut = 0;
    
    %input
    for i = 1 : obj.dimIn
        if ~isempty(obj.zDynInputDelay{i})
            cntDyn = cntDyn + 1;
            splitDyn(cntDyn) = obj.zDynInputDelay{i};
        end
        if ~isempty(obj.zStaticInputFunc{i})
            cntStatic = cntStatic + 1;
            splitStatic(cntStatic) = length(obj.zStaticInputFunc{i});
        end
    end
    
    % output
    if ~isempty(obj.zDynOutputDelay)
        splitDynOut = obj.zDynOutputDelay{1};
    end

    nPosSplits = sum(splitDyn) + sum(splitStatic) + sum(splitDynOut);

end

