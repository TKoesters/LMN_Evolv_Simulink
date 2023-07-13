function input = reNormInputs(obj,normedInput,dimensions2renorm)
%RENORMOUTPUT Summary of this function goes here
%   Detailed explanation goes here

if nargin == 2
    dimensions2renorm = 1 : obj.dimIn;
end

input = normedInput;
for i = 1 : length(dimensions2renorm) 
    input(i) = reNormData(normedInput(i),obj.inputRanges(i,:));
end

end

function u = reNormData(uNormed,range)
    u = (uNormed .* abs(range(2)-range(1))) + range(1);
end

