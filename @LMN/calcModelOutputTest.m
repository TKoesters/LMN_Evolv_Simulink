function outputTest = calcModelOutputTest(obj)
%CALCMODELOUTPUTTRAIN Summary of this function goes here
%   Detailed explanation goes here
    flag = false;
    if obj.trainFlag == true
        flag = true;
        obj = obj.setLocalTrainFlag(false);
        obj.trainFlag = false;
    end
    
    outputTest = obj.calcModelOutput(obj.inputTest,obj.outputTest);
    if flag
        obj.trainFlag = true;
        obj = obj.setLocalTrainFlag(true);
    end

end

