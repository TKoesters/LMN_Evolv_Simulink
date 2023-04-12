function lambda = getLambda(obj)
%GETLAMBDA Summary of this function goes here
%   Detailed explanation goes here

if length(obj.RegOptions.lambda) == 1
    if isempty(obj.RegOptions.lambda{1})
        lambda = 0;
    else
        lambda = obj.RegOptions.lambda{1};
    end
else
    error('ERROR: not implemented yet');
end

end

