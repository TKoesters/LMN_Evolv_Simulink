function investigateDeadTimeCrossCorrelation(obj,inputs2check,posNeg)
%INVESTIGATEDEADTIMECROSSCORRELATION Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    inputs2check = 1 : obj.dimIn;
    posNeg = 'both';
end

%figure;
maxLags = 100;

fig1 = figure;
%fig2 = figure;
plotTest = false;

for i = inputs2check
    
    
    % Train Data
    posInputTrain = normalize(obj.inputTrain(:,i),'zscore');
    negInputTrain = normalize(-obj.inputTrain(:,i),'zscore');
    outputTrain = normalize(obj.outputTrain,'zscore');
    
    [pxcorrTrain,lags] = xcorr(outputTrain,posInputTrain,maxLags,'unbiased');
    [nxcorrTrain,lags] = xcorr(outputTrain,negInputTrain,maxLags,'unbiased');
    [apcorrTrain] = xcorr(posInputTrain,maxLags,'unbiased');
    [ancorrTrain] = xcorr(negInputTrain,maxLags,'unbiased');
    
    
    % Test data if available 
    if ~isempty(obj.outputTest)
        plotTest = true;
        posInputTest = normalize(obj.inputTest(:,i),'zscore');
        negInputTest = normalize(-obj.inputTest(:,i),'zscore');
        outputTest = normalize(obj.outputTest,'zscore');
    
        [pxcorrTest,lags] = xcorr(outputTest,posInputTest,maxLags,'unbiased');
        [nxcorrTest,lags] = xcorr(outputTest,negInputTest,maxLags,'unbiased');
        [apcorrTest] = xcorr(posInputTest,maxLags,'unbiased');
        [ancorrTest] = xcorr(negInputTest,maxLags,'unbiased');
    end
    
    % OLD normalization inside
%     if contains(obj.info.inputDescription{i},'alpha')
%         [pxcorr,lags] = xcorr(normDataset(obj.outputTrain),normDataset(abs(obj.inputTrain(:,i))),maxLags,'unbiased');
%         [nxcorr,lags] = xcorr(normDataset(obj.outputTrain),normDataset(-abs(obj.inputTrain(:,i))),maxLags,'unbiased');
%     else
%         [pxcorr,lags] = xcorr(normDataset(obj.outputTrain),normDataset(obj.inputTrain(:,i)),maxLags,'unbiased');
%         [nxcorr,lags] = xcorr(normDataset(obj.outputTrain),normDataset(-obj.inputTrain(:,i)),maxLags,'unbiased');
%         [apcorr] = xcorr(normDataset(obj.outputTrain),maxLags,'unbiased');
%         [ancorr] = xcorr(normDataset(obj.outputTrain),maxLags,'unbiased');
%     end
    



    

    
    figure(fig1);
    nexttile;
    switch posNeg
        case 'both'
            plot(lags(maxLags+1:end),pxcorrTrain(maxLags+1:end));
            hold on
            plot(lags(maxLags+1:end),nxcorrTrain(maxLags+1:end));
            xlabel('lags $k$');
            ylabel('crossCorrelation');
            title(['$' obj.info.inputDescription{i} '$']);
            legend('positive','negative');
        case 'pos'
            plot(lags(maxLags+1:end),pxcorrTrain(maxLags+1:end));
            hold on
            xlabel('lags $k$');
            ylabel('crossCorrelation');
            title(['$' obj.info.inputDescription{i} '$']);
            legend('positive');
        case 'neg'
            plot(lags(maxLags+1:end),nxcorrTrain(maxLags+1:end));
            hold on
            xlabel('lags $k$');
            ylabel('crossCorrelation');
            title(['$' obj.info.inputDescription{i} '$']);
            legend('negative');
    end
            
    if plotTest
       
        switch posNeg
            case 'pos'
                plot(lags(maxLags+1:end),pxcorrTest(maxLags+1:end),'DisplayName','positive Test');
            case 'neg'
                plot(lags(maxLags+1:end),nxcorrTest(maxLags+1:end),'DisplayName','negative Test');
            case 'both'
                plot(lags(maxLags+1:end),pxcorrTest(maxLags+1:end),'DisplayName','positive Test');
                plot(lags(maxLags+1:end),nxcorrTest(maxLags+1:end),'DisplayName','negative Test');
        end
        
    end
    
%     figure(fig2);
%     nexttile;
%     plot(lags,pxcorrTrain.*apcorrTrain);
%     hold on
%     plot(lags,nxcorrTrain.*ancorrTrain);
%     xlabel('lags $k$');
%     title(['$' obj.info.inputDescription{i} '$']);
%     legend('positive','negative');
%     ylabel('crossCorrelation * autoCorrelation');

end


end