function inputDeadTime = xIncorpDeadTimes(obj,input)
%XINCORPDEADTIMES Incorporates Dead time to input signals
%   Detailed explanation goes here

inputDeadTime = zeros(size(input));

% iterate through all inputs
for i = 1 : length(input(1,:))
    
    if obj.xDeadTimes{i} ~= 0
    
        %cut and place input values in new vector
        inputDeadTime(1+obj.xDeadTimes{i}:end,i) = input(1:end-obj.xDeadTimes{i},i);

        %fill first values with first values of input
        inputDeadTime(1:1+obj.xDeadTimes{i},i) = input(1,i);
        
    else
        inputDeadTime(:,i) = input(:,i);
    end 
end


end