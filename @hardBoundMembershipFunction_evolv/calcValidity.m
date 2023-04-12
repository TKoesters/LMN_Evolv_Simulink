function validity = calcValidity(obj,zInput,smoothness)
%CALCVALIDITY Summary of this function goes here
%   Detailed explanation goes here

    if nargin<3
        smoothness = 1;
    end

    validity = 1 * ones(length(zInput(:,1)),1);
    for j = 1 : length(validity)
        for i = 1 : length(obj.bound)
            
           if ~isnan(obj.bound(i)) && ~isBehindBound(obj.bound(i),obj.direction(i),zInput(j,i)) 
                validity(j) = 0;
                break;
           end
        end
    end
 
end

function valid = isBehindBound(bound,direction,input)
    switch direction
        case 1
            valid = input > bound;
        case -1 
            valid = input < bound;
    end
end