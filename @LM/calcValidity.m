function [validity] = calcValidity(obj,input,output,plotFlag,smoothness,staticLinFlag,staticInputs)
%CALCVALIDITY Summary of this function goes here
%   Detailed explanation goes here
    
    if nargin<6
        staticLinFlag = false;
    end

    %% get zInput
    if staticLinFlag
        zInput = input(:,staticInputs==1);   
    elseif obj.adaptionFlag || obj.trainFlag %(test hier ob trainFlag auch geht)
        % for adaption take input directly as zInput
        zInput = input;
%     elseif obj.trainFlag % && false 
%         % for training take input directly as zInput
%         zInput = input;
    else
        % for evaluation and training calculate zRegressor (special case
        % training --> ZRegressor has to be build only once, This is
        % handled in buildZRegressor, therefore dont need to be considered
        % here.
        zInput = obj.buildZRegressor(input,output,plotFlag);
    end
    
    %% calc Validity
    validity = obj.validityFunction.calcValidity(zInput,smoothness);
    
end

