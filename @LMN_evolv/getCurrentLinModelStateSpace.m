function [A,B,C,D,offset] = getCurrentLinModelStateSpace(obj,method)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

theta = obj.getCurrentLinCoeffs(method);

%% create model from theta
maxDelay = obj.getMaxDelay;
A = [zeros(1,maxDelay);...
    eye(maxDelay-1,maxDelay)];

B = zeros(maxDelay,obj.dimIn);
for i = 1 : obj.dimIn
    % get corresponding impulse coeffs AND multiply by input range
    B(maxDelay-obj.xDynInputDelay{i}+1:end,i) = flipud(theta(obj.indexInput(i,1):obj.indexInput(i,2))) * (obj.inputRanges(i,2)-obj.inputRanges(i,1));
end

C = zeros(1,maxDelay);
C(end) = 1 * (obj.outputRange(2) - obj.outputRange(1));

D = zeros(1,obj.dimIn);

offset = theta(1) * (obj.outputRange(2) - obj.outputRange(1)) + obj.outputRange(1);

% 
% dumiTF = tf(0,1,1,'variable','z');
% linModel(1,1:obj.dimIn) = dumiTF;
% 
% for i = 1 : obj.dimIn
%     %numerator = fliplr(theta(obj.indexInput(i,1):obj.indexInput(i,2))');
%     numerator = theta(obj.indexInput(i,1):obj.indexInput(i,2))';
%     denominator = zeros(1,obj.xDynInputDelay{i}+1);
%     denominator(1) = 1;
% 
%     linModel(i) =  tf(numerator,denominator,1,'variable','z');
% end

end

