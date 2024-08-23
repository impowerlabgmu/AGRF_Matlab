[data, sheets] = Import_XSens('Pilot_DataCollectionSheets_Digitized_v2.xlsx');

for i = 1:length(sheets)
    count = 1;
    tempdat = data{i};
    for j = 1:length(tempdat.Trial)
        if tempdat.FP(j) == 99
            continue
        else
            TrialDat = split(tempdat.Trial(j),'_');
            TrialType{1,count} = TrialDat{1};
            TrialNum{1,count} = TrialDat{2};
            STR(1,count) = tempdat.FP(j);
            Leg(1,count) = tempdat.Leg(j);
            count = count+1;
        end
    end
    eval([char(sheets(i)) '.TrialType = TrialType;'])
    eval([char(sheets(i)) '.TrialNum = TrialNum;'])
    eval([char(sheets(i)) '.FP = STR;'])
    eval([char(sheets(i)) '.Leg = Leg;'])
    clearvars TrialType TrialNum STR Leg
end

clearvars -except PP*

save('CollectionInfo.mat')