function plotTrainingStats(obj)
%PLOTTRAININGSTATS Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(obj.history.trainingError)
   figure;
   
   if ~all(isnan(obj.history.testError))
        plotTestError = true;
        nSubplots = 3;
   else
        plotTestError = false;
        nSubplots = 2;
   end
   
   % training Error 
   subplot(nSubplots,1,1);
   plot(obj.history.trainingError);
   ylabel(obj.errorMeasurement);
   title('Training Error');

   % information Criterion
   subplot(nSubplots,1,2);
   plot(obj.history.informationCriterion);
   ylabel(obj.terminationCriterion);
   title('Termination Criterion');

   % test error if calculated
   if plotTestError
      subplot(nSubplots,1,3);
      plot(obj.history.testError);
      ylabel(obj.errorMeasurement);
      title('Test Error');
   end
   
   xlabel('Iteration $k$');
   
end

end

