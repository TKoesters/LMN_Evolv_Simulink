function [ATt,BTt,CTt,DTt,offset] = getCurrentLinModelStateSpaceTt(obj,method)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% get model coefficients
theta = obj.getCurrentLinCoeffs(method);

%% get max time delay
maxTimeDelay = max(cellfun(@max,obj.xDeadTimes));

%% create model from theta
maxDelay = obj.getMaxDelay;

delay = maxDelay + maxTimeDelay;

ATt = [zeros(1,delay);...
    eye(delay-1,delay)];

BTt = zeros(delay,obj.dimIn);
for i = 1 : obj.dimIn
    % get corresponding impulse coeffs AND multiply by input range
    BTt(maxTimeDelay - obj.xDeadTimes{i} + maxDelay-obj.xDynInputDelay{i}+1:end- obj.xDeadTimes{i},i) = flipud(theta(obj.indexInput(i,1):obj.indexInput(i,2))) ; %* (obj.inputRanges(i,2)-obj.inputRanges(i,1));
end

CTt = zeros(1,delay);
CTt(end) = 1;%  * (obj.outputRange(2) - obj.outputRange(1));

DTt = zeros(1,obj.dimIn);

offset = theta(1) ;% * (obj.outputRange(2) - obj.outputRange(1)) + obj.outputRange(1);





end

