function [staticParameter,pointerIncrement] = getStaticParameter(obj,thetaDyn,thetaPointer)
%GETSTATICPARAMETER Summary of this function goes here
%   Detailed explanation goes here
    if ~isempty(obj.xStaticInputFunc)
        % get parameter of static model
        % its possible that more than one parameter exits due to different
        % nonlinear inputs 
        pointerIncrement = length(obj.xStaticInputFunc);
        staticParameter = thetaDyn(thetaPointer:thetaPointer+pointerIncrement-1);
    else
        staticParameter = [];
        pointerIncrement = 0;
    end
end

