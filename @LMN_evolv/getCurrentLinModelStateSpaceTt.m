function [ATt,BTt,CTt,DTt,offset] = getCurrentLinModelStateSpaceTt(obj,method,delay,dimIn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

maxTimeDelay = getMaxDeadTime(obj.xDeadTimes);
maxDelay = obj.getMaxDelay;

if nargin==2
    delay = maxDelay + maxTimeDelay;
    dimIn = obj.dimIn;
end

%% get model coefficients
theta = obj.getCurrentLinCoeffs(method);

%% create model from theta

ATt = [zeros(1,delay);...
    eye(delay-1,delay)];

BTt = zeros(delay,dimIn);
for i = 1 : dimIn
    % get corresponding impulse coeffs AND multiply by input range
    BTt(maxTimeDelay - obj.xDeadTimes{i} + maxDelay-obj.xDynInputDelay{i}+1:end- obj.xDeadTimes{i},i) = flipud(theta(obj.indexInput(i,1):obj.indexInput(i,2))) ; %* (obj.inputRanges(i,2)-obj.inputRanges(i,1));
end

CTt = zeros(1,delay);
CTt(end) = 1;%  * (obj.outputRange(2) - obj.outputRange(1));

DTt = zeros(1,dimIn);

offset = theta(1) ;% * (obj.outputRange(2) - obj.outputRange(1)) + obj.outputRange(1);

end


%% functions 
function out = getMaxDeadTime(in)
    out = 0;
    for i  = 1 : length(in)
        out = max(out,in{i});
    end
end
