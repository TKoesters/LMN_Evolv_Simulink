function  plotTrainData(obj)
%PLOTTRAINDATA Summary of this function goes here
%   Detailed explanation goes here

figure('Name','Training Data');
numberOfPlots = obj.dimIn+1;

ax = subplot(numberOfPlots,4,1:3);
sbp(1) = ax;
plot(obj.outputTrain);
ylabel(['$' substituteRAW(obj.info.outputDescription) '$']);

subplot(numberOfPlots,4,4);
histogram(obj.outputTrain);

for i = 2 : numberOfPlots
    ax = subplot(numberOfPlots,4,4*(i-1)+1:4*(i-1)+3);
    sbp(i) = ax;
    plot(obj.inputTrain(:,i-1));
    try
        ylabel(['$' substituteRAW(obj.info.inputDescription{i-1}) '$']);
    catch
        ylabel(['$u_' num2str(i-1) '$']);
    end
    
    if i == numberOfPlots
        xlabel('samples [$k$]');
    end
    
    subplot(numberOfPlots,4,4*(i-1)+4);
    histogram(obj.inputTrain(:,i-1));
end

linkaxes(sbp,'x');

end

