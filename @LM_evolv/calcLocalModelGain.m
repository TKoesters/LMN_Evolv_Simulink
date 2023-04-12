function gain = calcLocalModelGain(obj)
%CALCLOCALMODELGAIN Summary of this function goes here
%   Detailed explanation goes here

numberInputs = length(obj.dynamicModels);

gain = zeros(numberInputs,1);

if obj.offset
    index = 2;
else
    index = 1;
end

for i = 1 : numberInputs
    [gain(i),index] = obj.dynamicModels{i}.getStaticParameter(obj.theta,index);
end


end

