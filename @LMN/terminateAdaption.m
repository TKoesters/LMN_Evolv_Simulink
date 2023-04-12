function obj = terminateAdaption(obj)
%TERMINATEADAPTION Summary of this function goes here
%   Detailed explanation goes here

%% Delete Adaption Flag
obj.adaptionFlag = false;
obj = obj.setLocalAdaptionFlag(false);

end

