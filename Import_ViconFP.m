%Import trial data from XSens output
%filenameV = 'Pilot00103.csv';

function [ViconDat,framerate] = Import_ViconFP(filenameV)


XTab = xlsread(filenameV); framerate = XTab(1,1);
dataV = readtable(filenameV,'VariableNamingRule','preserve');

dataVnorm = dataV{5:end-6,1:38};

ZeroNum = dataVnorm(2,:);

for i = 3:max(size(ZeroNum))
    dataVnorm(:,i) = dataVnorm(:,i) - ZeroNum(1,i);
end

ViconDat.Frame = dataVnorm(:,1) + dataVnorm(:,2);
ViconDat.FP4_F = dataVnorm(:,3:5);
ViconDat.FP4_M = dataVnorm(:,6:8);
ViconDat.FP4_COP = dataVnorm(:,9:11);
ViconDat.FP2_F = dataVnorm(:,12:14);
ViconDat.FP2_M = dataVnorm(:,15:17);
ViconDat.FP2_COP = dataVnorm(:,18:20);
ViconDat.FP1_F = dataVnorm(:,21:23);
ViconDat.FP1_M = dataVnorm(:,24:26);
ViconDat.FP1_COP = dataVnorm(:,27:29);
ViconDat.FP3_F = dataVnorm(:,30:32);
ViconDat.FP3_M = dataVnorm(:,33:35);
ViconDat.FP3_COP = dataVnorm(:,36:38);

end
