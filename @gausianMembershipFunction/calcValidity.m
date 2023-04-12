function validity = calcValidity(obj,zInput,smoothness)
%CALCVALIDITY Summary of this function goes here
%   Detailed explanation goes here

    % calculate the validity of the local model acording to its gausian
    % membership function (see Nelles p. 410 eq. 13.5)
%     validity = zeros(length(zInput(:,1)),1);
%     for i = 1 : length(zInput(:,1))
% %         sum = 0;
% %         for ii = 1 : length(obj.center)
% %             sum = sum + ((zInput(i,ii)-obj.center(ii))/obj.variance(ii))^2;
% %         end    
%         summe = sum(((zInput(i,:)' - obj.center)./obj.variance).^2);
%         validity(i,1) = exp(-0.5 * summe);
%     end
    
    % check if smoothness was submitted
    if nargin<3
        smoothness = 1;
    end

    % deutlich schneller Implementierung als oben
    validity = exp(-0.5 * sum(((zInput(:,:) - obj.center')./(obj.variance'.*smoothness)).^2,2));
 
end

