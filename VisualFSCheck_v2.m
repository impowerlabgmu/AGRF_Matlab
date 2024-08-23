%Visually Check Trials

clear
clc

load('NewData_v2.mat')
% load('CollectionInfo.mat')
j = 10;



for sheet = 1:j
    
    SheetFP = ForceDataUPD(:,:,sheet);
    SheetMot = MotionData(:,:,sheet);
    count = 1;
    VisualInspect = [];
    
    emptyCells = cellfun(@isempty,SheetFP);
    numTrials = length(find(~all(emptyCells,2)));
    
    for trial = 1:numTrials
            
        try
            if ~any(SheetFP{trial,6})
                continue
            end

            [FP1,FP2,FP3,FP4] = GetForceData(SheetFP{trial,1},SheetFP{trial,6});
            checkplots(FP1,FP2,FP3,FP4)
            
            pause
            
            
            VisualFS(trial) = input('Good Foot Strike?');
            Direction(trial) = input('Which direction?');
            
            if VisualFS(trial) == 0
                continue
            end
            
            [Samps, XSensSamps] = GetSamples(VisualFS(trial),SheetFP{trial,1}); %Recalculate Samples (Get from new force data)
            
            SheetFP{trial,9} = VisualFS(trial);
            SheetFP{trial,7} = Samps; %Write those changes to SheetFP
            SheetFP{trial,8} = XSensSamps;
            SheetFP{trial,5} = Direction(trial);
            VisualInspect(trial) = 1;
            
        catch
           VisualInspect(trial) = 0;
        end
    end
    
%     eval([PPID '= CurrPP;']);
    %Write CurPP to PP0_
    %ForceData(:,:,sheet) = SheetFP;
    ForceDataUPD2(:,:,sheet) = SheetFP;
    %Write SheetFP to ForceData
    
    sprintf('Participant %i is finished', sheet)

end

%Save CollectionInfo.mat
% save('CollectionInfoUPD.mat','PP01','PP02','PP03','PP04','PP05','PP06','PP07','PP08','PP09','PP10');
%Save AllData.mat
save('NewData_v3.mat','ForceDataUPD2','MotionData');

function [Samps, XSensSamps] = GetSamples(FPType,inputData)

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

XSensSamps = [fix(startidx/10) fix(endidx/10)];

end


function [FP1, FP2, FP3, FP4] = GetForceData(inputData,HS)

FP1 = inputData{1}(HS(1):HS(2),2); FP2 = inputData{2}(HS(1):HS(2),2);
FP3 = inputData{3}(HS(1):HS(2),2); FP4 = inputData{4}(HS(1):HS(2),2);

end



