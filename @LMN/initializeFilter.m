function obj = initializeFilter(obj)
%INITIALIZEFILTER Summary of this function goes here
%   Detailed explanation goes here

%% iterate through all inputs
for i = 1 : obj.dimIn
    obj.xSpaceFilterPuffer{i} = ones(length(obj.xSpaceInputFilterPoles{i}),1) * 0.5;
    obj.zSpaceFilterPuffer{i} = ones(length(obj.zSpaceInputFilterPoles{i}),1) * 0.5;
end

end

