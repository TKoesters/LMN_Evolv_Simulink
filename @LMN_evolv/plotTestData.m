function  plotTestData(obj)
%PLOTTESTDATA Summary of this function goes here
%   Detailed explanation goes here

figure('Name','Test Data');
numberOfPlots = obj.dimIn+1;

ax = subplot(numberOfPlots,4,1:3);
sbp(1) = ax;
plot(obj.outputTest);
ylabel(['$' substituteRAW(obj.info.outputDescription) '$']);

subplot(numberOfPlots,4,4);
histogram(obj.outputTest);

for i = 2 : numberOfPlots
    ax = subplot(numberOfPlots,4,4*(i-1)+1:4*(i-1)+3);
    sbp(i) = ax;
    plot(obj.inputTest(:,i-1));
    ylabel(['$' substituteRAW(obj.info.inputDescription{i-1}) '$']);
    
    if i == numberOfPlots
        xlabel('samples [$k$]');
    end
    
    subplot(numberOfPlots,4,4*(i-1)+4);
    histogram(obj.inputTest(:,i-1));
end

linkaxes(sbp,'x');


end


