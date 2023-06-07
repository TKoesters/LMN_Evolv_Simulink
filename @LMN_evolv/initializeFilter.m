function obj = initializeFilter(obj)
%INITIALIZEFILTER Summary of this function goes here
%   Detailed explanation goes here

%% set every filter pole to zero if not present (needed for code generation)
%% iterate through all inputs
for i = 1 : obj.dimIn

    if isempty(obj.xSpaceInputFilterPoles{i})
        obj.xSpaceInputFilterPoles{i} = 0;
    end
    if isempty(obj.zSpaceInputFilterPoles{i})
        obj.zSpaceInputFilterPoles{i} = 0;
    end
    

    obj.xSpaceFilterPuffer{i} = ones(length(obj.xSpaceInputFilterPoles{i}),1) * 0.5;
    obj.zSpaceFilterPuffer{i} = ones(length(obj.zSpaceInputFilterPoles{i}),1) * 0.5;
end

end

