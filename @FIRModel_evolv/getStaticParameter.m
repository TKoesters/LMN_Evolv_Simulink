function [staticParameter, thetaPointerNew] = getStaticParameter(obj,thetaDyn,thetaPointer)
%GETSTATICPARAMETER Summary of this function goes here
%   Detailed explanation goes here

staticParameter = sum(thetaDyn(thetaPointer:thetaPointer+obj.inputDelays-1));
thetaPointerNew = thetaPointer+obj.inputDelays;

end

