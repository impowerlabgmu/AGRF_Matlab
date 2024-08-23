%Visually Check Trials

clear
clc

load('NewData.mat')
load('CollectionInfo.mat')
load('MatchedTrials.mat')

j = 10;

for sheet = 1%:j

    if sheet < 10
        PPID = ['PP0' num2str(sheet)];
    else
        PPID = ['PP' num2str(sheet)];
    end

    CurrPP = eval(PPID);
    SheetFP = ForceData(:,:,sheet);
    SheetMot = MotionData(:,:,sheet);
    count = 1;
    VisualInspect = [];

    for trial = 1:length(SheetFP)

%         Mapping = FinalMatches{sheet};
%         trialnumIMU = Mapping(trial,1);
%         trialnumFP = Mapping(trial,2);
%         try
            [y, FP1,FP2,FP3,FP4] = GetForceData(CurrPP.FP(trial),SheetFP{trial,1},SheetFP{trial,6});
            checkplots(FP1,FP2,FP3,FP4)

            pause

            VisualFS(trial) = input('Good Footstrike?');
            Direction(trial) = input('Which direction?');

            CurrPP.FP(trialnumFP) = VisualFS(trial); %Write Changes to CurPP

            if VisualFS(trial) == 0
                continue
            end

            Samps = GetSamples(CurrPP.FP(trialnumFP),SheetFP{trial,1});%Recalculate Samples (Get from new force data)
            SheetFP{trial,6} = Samps; %Write those changes to SheetFP
            SheetFP{trial,5} = Direction(trial);
            VisualInspect(trial) = 1;

%         catch
           VisualInspect(trial) = 0;
%         end
    end

    eval([PPID '= CurrPP;']);
    %Write CurPP to PP0_
    ForceData(:,:,sheet) = SheetFP;
    %Write SheetFP to ForceData

end

%Save CollectionInfo.mat
save('CollectionInfoUPD.mat','PP01','PP02','PP03','PP04','PP05','PP06','PP07','PP08','PP09','PP10');
%Save AllData.mat
save('AllData_v3.mat','ForceData','MotionData');

function Samps = GetSamples(FPType,inputData)

FP1 = inputData{1}(:,3); FP2 = inputData{2}(:,3);
FP3 = inputData{3}(:,3); FP4 = inputData{4}(:,3);

if FPType == 4
    output = FP4;
elseif FPType == 1
    output = FP3;
elseif FPType == 2
    output = FP2;
elseif FPType == 3
    output = FP1;
elseif FPType == 12
    output = FP3 + FP2;
elseif FPType == 23
    output = FP2 + FP1;
end

Tot_Fz = output;

%Detect Heelstrikes from FP
Tot_Fz(abs(Tot_Fz)<25) = 0;

idx = find(abs(Tot_Fz)>0);
D_idx = diff(idx);

idx(D_idx>1) = [];
startidx = idx(1); endidx = idx(end);

Samps = [startidx endidx];

end

function [output, FP1, FP2, FP3, FP4] = GetForceData(FPType,inputData,HS)

FP1 = inputData{1}(HS(1):HS(2),2); FP2 = inputData{2}(HS(1):HS(2),2);
FP3 = inputData{3}(HS(1):HS(2),2); FP4 = inputData{4}(HS(1):HS(2),2);

if FPType == 4
    output = FP4;
elseif FPType == 1
    output = FP3;
elseif FPType == 2
    output = FP2;
elseif FPType == 3
    output = FP1;
elseif FPType == 12
    output = FP3 + FP2;
elseif FPType == 23
    output = FP2 + FP1;
end

end



