function [staticParameter, thetaPointerNew] = getStaticParameter(obj,thetaDyn,thetaPointer)
%GETSTATICPARAMETER Summary of this function goes here
%   Detailed explanation goes here

staticParameter = sum([thetaDyn(thetaPointer:thetaPointer+obj.inputDelays-1)]) /...
    sum([1; -1*thetaDyn(end-obj.outputDelays+1:end)]);

GTest = tf([thetaDyn(thetaPointer:thetaPointer+obj.inputDelays-1)]',[1; -1*thetaDyn(end-obj.outputDelays+1:end)]',0.2,'Variable','z^-1');

gain = dcgain(GTest);

thetaPointerNew = thetaPointer+obj.inputDelays;

end

