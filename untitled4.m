% ICCMaxTot = [1, 1];
% ICCMinTot = [1, 1];
% 
% for i = 1:length(ICCDataMax)
%     ICCMaxTot = [ICCMaxTot; ICCDataMax{i}];
%     ICCMinTot = [ICCMinTot; ICCDataMin{i}];
% end
% 
% save('ICCData_unWeighted.mat','ICCMaxTot','ICCMinTot');


clear
clc

load('ICCData_UnWeighted.mat')

%For Weighted Data
% ICCMaxTot(:,2) = ICCMaxTot(:,2)*9.81;
% ICCMinTot(:,2) = ICCMinTot(:,2)*9.81;
% 
% ICCMaxTot(1,2) = 1; ICCMinTot(1,2) = 1;

ICCMax = ICC(ICCMaxTot,'A-1');
ICCMin = ICC(ICCMinTot,'A-1');

[~, LBMax, UBMax, ~, ~, ~, ~] = ICC(ICCMaxTot,'A-1');
[~, LBMin, UBMin, ~, ~, ~, ~] = ICC(ICCMinTot,'A-1');

absErrorMax  = abs(ICCMaxTot(:,1) - ICCMaxTot(:,2))/9.81;
absErrorMin = abs(ICCMinTot(:,1) - ICCMinTot(:,2))/9.81;


meanProp = mean(absErrorMax); stdProp = std(absErrorMax);
meanBrake = mean(absErrorMin); stdBrake = std(absErrorMin);

MDCProp = getMDC(ICCMaxTot);
MDCBrake = getMDC(ICCMinTot);
formatSpecProp = 'Propulsion: %1.4f +/- %1.4f \n';
formatSpecBrake = 'Braking: %1.4f +/- %1.4f \n';

fprintf(formatSpecProp,meanProp,stdProp)
fprintf(formatSpecBrake,meanBrake,stdBrake)


hold on
boxchart([absErrorMax,absErrorMin])



function MDC = getMDC(PairedData)

data = PairedData(:,1)/9.81;

SEM = std(data)./sqrt(length(data));

MDC = 1.96*(SEM)*sqrt(2);

end