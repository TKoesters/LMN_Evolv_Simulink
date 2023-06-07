function [obj,xFilteredInput,zFilteredInput] = filterData(obj,xInput,zInput)
%FILTERDATA Summary of this function goes here
%   Detailed explanation goes here

if nargin<3
    zInput = xInput;
end

%% iterate through all x-Space filter (xSpaceInputFilterPoles)
xFilteredInput = xInput;
for i = 1 : obj.dimIn
    switch length(obj.xSpaceInputFilterPoles{i})
        
        case 0
            % disp(['Input ' num2str(i) ' is not filtered in x-Space']);
        
        case 1
            xFilteredInput(i) = xInput(i) * (1-obj.xSpaceInputFilterPoles{i}) + obj.xSpaceFilterPuffer{i} * obj.xSpaceInputFilterPoles{i};
            obj.xSpaceFilterPuffer{i} = xFilteredInput(i);

        case 2
            xFilteredInput(i) = xInput(i) * prod([1; 1]-obj.xSpaceInputFilterPoles{i})...
                + obj.xSpaceFilterPuffer * [sum(obj.xSpaceInputFilterPoles{i}); -prod(obj.xSpaceInputFilterPoles{i})];
            help = obj.xSpaceFilterPuffer{i} ;
            obj.xSpaceFilterPuffer{i} = [xFilteredInput; help(1)];
            
        otherwise
            error('ERROR: no valid poles were given for filter');
    end
end


%% iterate through all z-Space filter
zFilteredInput = zInput;
for i = 1 : obj.dimIn
    switch length(obj.zSpaceInputFilterPoles{i})
        
        case 0
            % disp(['Input ' num2str(i) ' is not filtered in z-Space']);
        
        case 1
            zFilteredInput(i) = zInput(i) * (1-obj.zSpaceInputFilterPoles{i}) + obj.zSpaceFilterPuffer{i} * obj.zSpaceInputFilterPoles{i};
            obj.zSpaceFilterPuffer{i} = zFilteredInput(i);
        case 2
            zFilteredInput(i) = zInput(i) * prod([1; 1]-obj.zSpaceInputFilterPoles{i})...
                + obj.zSpaceFilterPuffer' * [sum(obj.zSpaceInputFilterPoles{i}); -prod(obj.zSpaceInputFilterPoles{i})];
            help = obj.zSpaceFilterPuffer{i} ;
            obj.zSpaceFilterPuffer{i} = [zFilteredInput(i); help(1)];
        otherwise
            error('ERROR: no valid poles were given for filter');
    end
end

end

