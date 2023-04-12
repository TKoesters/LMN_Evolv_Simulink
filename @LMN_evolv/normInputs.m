function inputNormed = normInputs(obj,input)
%NORMINPUTS Summary of this function goes here
%   Detailed explanation goes here
inputNormed = zeros(size(input));

% if input Ranges is empty
if isempty(obj.inputRanges)
    obj.inputRanges = [min(input)' , max(input)'];
    warning('WARNING: No ranges were set yet. Chose min an max values of training inputs as Range');    
end

for i = 1 : obj.dimIn
    inputNormed(:,i) = normData(input(:,i),obj.inputRanges(i,:));
end

end

function normedData = normData(u,range)
    normedData = (u-range(1))./abs(range(2)-range(1));
end