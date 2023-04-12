function inputDeadTime = zIncorpDeadTimes(obj,input)
%ZINCORPDEADTIMES Summary of this function goes here
%   Detailed explanation goes here

inputDeadTime = zeros(size(input));

% iterate through all inputs
for i = 1 : length(input(1,:))
    
    if obj.zDeadTimes{i} ~= 0

        %cut and place input values in new vector
        inputDeadTime(1+obj.zDeadTimes{i}:end,i) = input(1:end-obj.zDeadTimes{i},i);

        %fill first values with first values of input
        inputDeadTime(1:1+obj.zDeadTimes{i},i) = input(1,i);
        
    else
        inputDeadTime(:,i) = input(:,i);
    end
end


end

