function compareModel(obj,trainOrTest)
%COMPAREMODEL Summary of this function goes here
%   Detailed explanation goes here

if nargin==1
    if isempty(obj.outputTest)
        trainOrTest = {'train'};
    else
        trainOrTest = {'train','test'};
    end
end

if nargin==2
    trainOrTest = {trainOrTest};
end

for i = 1 : length(trainOrTest)
   switch trainOrTest{i}
       case 'train'
           figure
           sb1 = subplot(3,1,1:2);
           yHat = obj.calcModelOutputTrain;
           plot(obj.outputTrain);
           hold on
           plot(yHat);
           legend('$y$','$\hat y$');
           xlabel('samples $k$');
           ylabel(['$' substituteRAW(obj.info.outputDescription) '$']);
           %title('Train Data');
            
           sb2 = subplot(3,1,3);
           for ii = 1 : obj.dimIn
               plot(normDataset(obj.inputTrain(:,ii)));
               hold on;
           end
           xlabel('samples $k$');

           for ii = 1 : length(obj.info.inputDescription)
                legendNames{i} = ['$' substituteRAW(obj.info.inputDescription{i}) '$']
           end
           legend(legendNames);
           linkaxes([sb1, sb2],'x');
           
           figure
           error = yHat-obj.outputTrain;
           subplot(1,3,1);
           plot(error);
           xlabel('samples $k$');
           ylabel('error $e$');
           
           subplot(1,3,2);
           plot(obj.outputTrain, yHat, '.');
           hold on;
           if ~isempty(obj.outputNonlinearity)
                plot([min(obj.outputTrain),max(obj.outputTrain)],[min(obj.outputTrain),max(obj.outputTrain)],'r-');
                xlim([min(obj.outputTrain),max(obj.outputTrain)]);
                ylim([min(obj.outputTrain),max(obj.outputTrain)]);
           else
                plot([obj.outputRange(1),obj.outputRange(2)],[obj.outputRange(1),obj.outputRange(2)],'r-');
                xlim(obj.outputRange);
                ylim(obj.outputRange);
           end
           xlabel('$y$');
           ylabel('$\hat y$');
           axis equal;

           
           subplot(1,3,3);
           histogram(error,'Normalization','probability');
           xlabel('error $e$');
           [mu, sigma] = normfit(error);
           hold on;
           x = normpdf(min(error):0.1:max(error),mu,sigma);
           tDist = fitdist(error,'tLocationScale');
           plot(min(error):0.1:max(error),x);
           plot(min(error):0.1:max(error),pdf(tDist,min(error):0.1:max(error)));
           legend('$e$',['normDist: $\mu = ' num2str(mu) '$ , $\sigma = ' num2str(sigma) '$'],...
               ['t-Dist: $\mu = ' num2str(round(tDist.mu,2)) '$ , $\sigma = ' num2str(round(tDist.sigma,2)) '$']);
           
           
           figure
           xDeadTime  = obj.localModels{1}.xIncorpDeadTimes(obj.inputTrain);
           for ii = 1:obj.dimIn
               correlation(ii) = corr(normDataset(error),normDataset(xDeadTime(:,ii)));
           end
           cats = reordercats(categorical(obj.info.inputDescription),obj.info.inputDescription);
           bar(cats,correlation);
           title('Train data');
           
           figure
           xDeadTime  = obj.localModels{1}.xIncorpDeadTimes(obj.inputTrain);
           for ii = 1:obj.dimIn
               nexttile;
               crosscorr(error,xDeadTime(:,ii),50);
               title(obj.info.inputDescription{ii});
           end
           
           
           figure
           for ii = 1 : obj.dimIn
               plot(normDataset(xDeadTime(80:end,ii)));
               hold on;
           end
           hold on
           plot(normDataset(error(80:end)));
           
           
           
           
           
           
       case 'test'
           yHat = obj.calcModelOutputTest;
           figure
           plot(obj.outputTest);
           hold on
           plot(yHat);
           legend('$y$','$\hat y$');
           xlabel('samples $k$');
           ylabel(['$' substituteRAW(obj.info.outputDescription) '$']);
           title('Test Data');
           
           
            figure
           error = yHat-obj.outputTest;
           subplot(1,3,1);
           plot(error);
           xlabel('samples $k$');
           ylabel('error $e$');
           
           subplot(1,3,2);
           plot(obj.outputTest, yHat, '.');
           hold on;
           if ~isempty(obj.outputNonlinearity)
                plot([min(obj.outputTest),max(obj.outputTest)],[min(obj.outputTest),max(obj.outputTest)],'r-');
                xlim([min(obj.outputTest),max(obj.outputTest)]);
                ylim([min(obj.outputTest),max(obj.outputTest)]);
           else
                plot([obj.outputRange(1),obj.outputRange(2)],[obj.outputRange(1),obj.outputRange(2)],'r-');
                xlim(obj.outputRange);
                ylim(obj.outputRange);
           end
                
                xlabel('$y$');
           ylabel('$\hat y$');
           axis equal;

           
           subplot(1,3,3);
           histogram(error,'Normalization','probability');
           xlabel('error $e$');
           [mu, sigma] = normfit(error);
           hold on;
           x = normpdf(min(error):0.1:max(error),mu,sigma);
           tDist = fitdist(error,'tLocationScale');
           plot(min(error):0.1:max(error),x);
           plot(min(error):0.1:max(error),pdf(tDist,min(error):0.1:max(error)));
           legend('$e$',['normDist: $\mu = ' num2str(mu) '$ , $\sigma = ' num2str(sigma) '$'],...
               ['t-Dist: $\mu = ' num2str(round(tDist.mu,2)) '$ , $\sigma = ' num2str(round(tDist.sigma,2)) '$']);
           
           
           
           
           figure
           xDeadTime  = obj.localModels{1}.xIncorpDeadTimes(obj.inputTest);
           for ii = 1:obj.dimIn
               correlation(ii) = corr(normDataset(error),normDataset(xDeadTime(:,ii)));
           end
           cats = reordercats(categorical(obj.info.inputDescription),obj.info.inputDescription);
           bar(cats,correlation);
           title('Test data');
           
           
   end
end

end

