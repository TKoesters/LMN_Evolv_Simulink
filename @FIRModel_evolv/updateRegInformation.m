function obj = updateRegInformation(obj, RegOptions, p)
%UPDATEREGINFORMATION Summary of this function goes here
%   Detailed explanation goes here

    if ~length(RegOptions.a) == 1
        RegOptions.a = RegOptions.a(p);
    end
    if ~length(RegOptions.alpha) == 1
        RegOptions.a = RegOptions.alpha(p);
    end

    obj.RegOptions = RegOptions;

end

