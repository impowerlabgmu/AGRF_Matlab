


[FPData,FPFrameRate] = Import_ViconFP(['AGRF001_SS_10.csv']);

hold on
plot(FPData.FP1_F(:,3))
plot(FPData.FP2_F(:,3))
plot(FPData.FP3_F(:,3))
plot(FPData.FP4_F(:,3))
hold off

totmax = min([FPData.FP1_F(:,3) FPData.FP2_F(:,3) FPData.FP3_F(:,3) FPData.FP4_F(:,3)]);

FtotY = FPData.FP1_F(:,2)+ FPData.FP2_F(:,2)+FPData.FP3_F(:,2)+FPData.FP4_F(:,2);

plot(FtotY);


% SCALEmax = totmax/1.2;
% 
% mass = max(abs(SCALEmax/9.81))