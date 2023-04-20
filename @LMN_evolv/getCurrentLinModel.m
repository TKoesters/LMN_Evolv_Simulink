function [linModel] = getCurrentLinModel(obj,method)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

theta = obj.getCurrentLinCoeffs(method);

%% create model from theta
dumiTF = tf(0,1,1,'variable','z');
linModel(1,1:obj.dimIn) = dumiTF;

for i = 1 : obj.dimIn
    %numerator = fliplr(theta(obj.indexInput(i,1):obj.indexInput(i,2))');
    numerator = theta(obj.indexInput(i,1):obj.indexInput(i,2))';
    denominator = zeros(1,obj.xDynInputDelay{i}+1);
    denominator(1) = 1;

    linModel(i) =  tf(numerator,denominator,1,'variable','z');
end

end

