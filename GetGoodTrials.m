%%Mark Good Trials

GoodTrials = [];


for i =1:10

    if i<10
        numstr = ['0' num2str(i)];
    else
        numstr = num2str(i);
    end

    trialname = ['P001_SS_' numstr '.csv'];

    hold on
    plot(FPData.FP1_F(:,3))
    plot(FPData.FP2_F(:,3))
    plot(FPData.FP3_F(:,3))
    plot(FPData.FP4_F(:,3))
    hold off

    totmax = min([FPData.FP1_F(:,3) FPData.FP2_F(:,3) FPData.FP3_F(:,3) FPData.FP4_F(:,3)]);

    FtotY = FPData.FP1_F(:,2)+ FPData.FP2_F(:,2)+FPData.FP3_F(:,2)+FPData.FP4_F(:,2);

    plot(FtotY);

    Value = input('Good Trial?');

    GoodTrialsSS(i) = Value;

end

for i =1:18

    if i<10
        numstr = ['0' num2str(i)];
    else
        numstr = num2str(i);
    end

    trialname = ['AGRF001_SS_' numstr '.csv'];


    [FPData,FPFrameRate] = Import_XSens(trialname);

    hold on
    plot(FPData.FP1_F(:,3))
    plot(FPData.FP2_F(:,3))
    plot(FPData.FP3_F(:,3))
    plot(FPData.FP4_F(:,3))
    hold off

    totmax = min([FPData.FP1_F(:,3) FPData.FP2_F(:,3) FPData.FP3_F(:,3) FPData.FP4_F(:,3)]);

    FtotY = FPData.FP1_F(:,2)+ FPData.FP2_F(:,2)+FPData.FP3_F(:,2)+FPData.FP4_F(:,2);

    plot(FtotY);

    Value = input('Good Trial?');

    GoodTrialsSS(i) = Value;

end