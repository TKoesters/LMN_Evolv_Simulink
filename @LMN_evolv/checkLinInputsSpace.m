function [obj] = checkLinInputsSpace(obj)
%CHECKLININPUTSSPACE Summary of this function goes here
%   Detailed explanation goes here


% check if all input functions are linear 
linFunc = @(u)u;

obj.xlinInputSpaceFlag = true;
obj.zlinInputSpaceFlag = true;

for i = 1 : obj.dimIn
    % check xSpace
    if isempty(obj.xStaticInputFunc{i})  %|| ~isempty(obj.xDynInputDelay)
        obj.xlinInputSpace(i) = false; 
    elseif (length(obj.xStaticInputFunc{i}) == 1 && checkFunctionEquality(obj.xStaticInputFunc{i}{1},linFunc))
        obj.xlinInputSpace(i) = true; 
    else
        obj.xlinInputSpaceFlag = false;
    end
    
    % check zSpace
    if isempty(obj.zStaticInputFunc{i}) %|| ~isempty(obj.zDynInputDelay)
        obj.zlinInputSpace(i) = false; 
    elseif (length(obj.zStaticInputFunc{i}) == 1 && checkFunctionEquality(obj.zStaticInputFunc{i}{1},linFunc))
        obj.zlinInputSpace(i) = true; 
    else
        obj.zlinInputSpaceFlag = false;
    end
end

end

function eq = checkFunctionEquality(func1, func2)

   % Test Data points 
   testPoints = rand(5,1);
   
   if func1(testPoints) == func2(testPoints)
       eq = true;
   else
       eq = false;
   end

end