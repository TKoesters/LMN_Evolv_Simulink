function R = buildRegularization(obj,method)
%BUILDREGULARIZATION Summary of this function goes here
%   Detailed explanation goes here

if strcmp(method,'RIDGE')
    R = eye(length(obj.xStaticInputFunc));
else
    R = zeros(length(obj.xStaticInputFunc));
end

end

