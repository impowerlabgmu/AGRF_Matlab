%This script will mimic 'Individual_Trials', but use regression
%coefficients that have already been processed for the Participant-Specific
%Data

%Edited 1/8/2023 - N. Glover

clear
clc

load('NewData_v3.mat')
load('CollectionInfoUPD.mat')
load('MatchedTrials_v4.mat')
% load('FullCoefficients_Weighted.mat')
load('FullCoefficients.mat')

j = 10;

count2 = 1;

FullCoeffs_P = []; stringID = [];



Sep_bySpeed = 0;

if Sep_bySpeed == 1

    Cond = 'Slow';
    TCurr = T(T.Condition == Cond,:);
else
    TCurr = T;
end


weighting_on = 0; %1 turns weighting on, 0 turns it off
max_weighting_factor = 10; % Adds a 10% weighting factor to max points
min_weighting_factor = 10; % Adds a 10% weighting factor to min points

for sheet = 1:j
    tempID = [];
    count = 1;
    
    CurrTable = TCurr(TCurr.PID == num2str(sheet),:);
    CurrCoeffs = [mean(CurrTable.C0), mean(CurrTable.C1), mean(CurrTable.C2), mean(CurrTable.C3), mean(CurrTable.C4)];

    if sheet < 10
        PPID = ['PP0' num2str(sheet)];
    else
        PPID = ['PP' num2str(sheet)];
    end

    CurrPP = eval(PPID);

    mass = CurrPP.mass;

    SheetFP = ForceDataUPD2(:,:,sheet);
    SheetMot = MotionData(:,:,sheet);
    VisualInspect = [];

    TC = [];
 
    for trial = 1:length(FinalMatches{sheet})
        Mapping = FinalMatches{sheet};
        trialnumIMU = Mapping(trial,1);
        trialnumFP = Mapping(trial,2);
        
%         pause
         try

            if CurrPP.Leg{trialnumIMU} == 0 || ~any(SheetFP{trial,6})
                continue
%             elseif ~matches(SheetFP{trialnumFP,2},Cond)    %
%                 continue
            end

            [X,Samp] = GetMotionData(SheetMot{trialnumIMU,7},SheetMot{trialnumIMU,1},SheetFP{trialnumFP,7});
            X = [ones(size(X(:,1))) X];
            [y, FP1,FP2,FP3,FP4] = GetForceData(SheetFP{trialnumFP,9},SheetFP{trialnumFP,1},SheetFP{trialnumFP,5},Samp,mass);
            VisualInspect(trial) = 1;
%             y = y./9.81;

            if weighting_on == 1
                [X_Weight, yWeight] = AddWeighting(X,y,min_weighting_factor,max_weighting_factor);
                X = X_Weight;
                y = yWeight;
            end

           
            [RSquared{count,sheet},RMSE,MaxR,MinR] = Calc_RSquared(CurrCoeffs,X,y,0);

            tempRS = RSquared{count,sheet};

            Cell_plot{count,1} = CurrCoeffs*X';
            Cell_plot{count,2} = y;

            ICCDataMax{sheet}(count,1:2) = [max(y), MaxR];
            ICCDataMin{sheet}(count,1:2) = [min(y), MinR];
            R2Data{sheet}(count) = tempRS;
            RMSEData{sheet}(count) = [RMSE];


            if tempRS > -0.4
                ScatterData(count2,1:3) = [abs(SheetMot{trialnumIMU,6}), tempRS, sheet];
                count2 = count2+1;
            else
                disp(num2str(tempRS))
            end

            tempID = [tempID; string(SheetFP{trialnumFP,2})];

            count = count + 1;

        catch
            VisualInspect(trial) = 0;
        end
    end

    [r,c] = size(TC);
    id = ones(r,1)*sheet;

    stringID = [stringID; tempID];

    ReviewTrials{sheet} = VisualInspect;
    numBadTrials(sheet) = sum(VisualInspect);
    numGoodTrials(sheet) = length(VisualInspect) - numBadTrials(sheet);


end

G = ScatterData(any(ScatterData,2),:);

%This shows R-Squared by Speed
%scatter(ScatterData(:,1),ScatterData(:,2))

%This shows R-Sqared by participant
scatter(ScatterData(:,3),ScatterData(:,2))

% titlestring = (['Combined R-Squared for ' Cond ' Condition']);
% title(titlestring)
% xlim([0 10])
% ylim([0 1])

[r2,c2] = size(FullCoeffs); c2 = c2+3;

T2 = table('Size',[r2,c2],'VariableNames',{'C0','C1','C2','C3','C4','PID','Condition','RSquared','Speed'},'VariableTypes',{'double','double','double','double','double','categorical','categorical','double','double'});
T2.C0 = FullCoeffs(:,1); T2.C1 = FullCoeffs(:,2); T2.C2 = FullCoeffs(:,3); T2.C3 = FullCoeffs(:,4); T2.C4 = FullCoeffs(:,5);
T2.PID = categorical(FullCoeffs(:,6)); 
T2.Condition = categorical(stringID); 
T2.RSquared = G(:,2); 
T2.Speed = G(:,1);

PID1 = T2(T2.PID == '1',:);
PID2 = T2(T2.PID == '2',:);
PID3 = T2(T.PID == '3',:);
PID4 = T2(T2.PID == '4',:);
PID5 = T2(T2.PID == '5',:);
PID6 = T2(T2.PID == '6',:);
PID7 = T2(T2.PID == '7',:);
PID8 = T2(T2.PID == '8',:);
PID9 = T2(T2.PID == '9',:);
PID10 = T2(T2.PID == '10',:);


% for v = 1:10
%     ICCMinFinal(v,1) = abs(ICCMin{v}(1,2));
%     ICCMaxFinal(v,1) = abs(ICCMax{v}(1,2));
% end




function [XWeighted, yWeighted] = AddWeighting(X,y,weightmin,weightmax)

[val_min, idx_min] = min(y); Xmin = X(idx_min,:);
[val_max, idx_max] = max(y); Xmax = X(idx_max,:);

size_min_add = ceil((weightmin/100)*length(y));
size_max_add = ceil((weightmax/100)*length(y));

min_add = repmat(val_min,1,size_min_add);
max_add = repmat(val_max,1,size_max_add);
Xmin_add = repmat(Xmin,size_min_add,1);
Xmax_add = repmat(Xmax,size_max_add,1);

XWeighted = [X;Xmin_add;Xmax_add];
yWeighted = [y;min_add',max_add'];

end

function [output,FP1, FP2, FP3, FP4] = GetForceData(FPType,inputData,direction,HS,mass)

FP1 = inputData{1}(HS(1):10:HS(end),2); FP2 = inputData{2}(HS(1):10:HS(end),2);
FP3 = inputData{3}(HS(1):10:HS(end),2); FP4 = inputData{4}(HS(1):10:HS(end),2);

% FP1_1 = inputData{1}(HS1(1):10:HS1(end),2); FP2_1 = inputData{2}(HS1(1):10:HS1(end),2);
% FP3_1 = inputData{3}(HS1(1):10:HS1(end),2); FP4_1 = inputData{4}(HS1(1):10:HS1(end),2);
% 
% FP1 = FP1_1()

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

Toutput = (output/(mass))*direction;

[b,a] = butter(2,10/(100/2),'low');

output = filtfilt(b,a,Toutput);

[Max, MaxIDX] = max(output);
[Min, MinIDX] = min(output);

if MinIDX > MaxIDX
    output = output*(-1);
end


end

function [output, Samples] = GetMotionData(LType,inputData,HS)

start_HS1 = fix(HS(1)/10);
end_HS1 = fix(HS(2)/10);

Angles = inputData{1};
PelvisAccel = inputData{2};
TorsoAccel = inputData{3};

if Angles.LHip(start_HS1,3) > Angles.RHip(start_HS1,3)
    LegType = 'L';
else
    LegType = 'R';
end

if LegType == 'L'
    Hip = Angles.LHip(start_HS1:end_HS1,3);
    Knee = Angles.LKnee(start_HS1:end_HS1,3);
else
    Hip = Angles.RHip(start_HS1:end_HS1,3);
    Knee = Angles.RKnee(start_HS1:end_HS1,3);
end


%Butterworth Filter
% [b,a] = butter(2,15/(100/2),'low');
% Hip = filtfilt(b,a,Hip);
% Knee = filtfilt(b,a,Knee);
% PelvisAccel.X = filtfilt(b,a,PelvisAccel.X);
% TorsoAccel.X = filtfilt(b,a,TorsoAccel.X);


%Moving Average Filter
B = 1/1*ones(1,1);
Hip = filter(B,1,Hip);
Knee = filter(B,1,Knee);
PelvisAccel.X = filter(B,1,PelvisAccel.X);
TorsoAccel.X = filter(B,1,TorsoAccel.X);



Samples = (start_HS1:end_HS1)*10;


%output = [sind(Hip) sind(Knee) PelvisAccel.X(start_HS1:end_HS1) TorsoAccel.X(start_HS1:end_HS1)]; %PelvisAccel.Z(start_HS1:end_HS1) TorsoAccel.Z(start_HS1:end_HS1)];
output = [(Hip) (Knee) PelvisAccel.X(start_HS1:end_HS1) TorsoAccel.X(start_HS1:end_HS1)]; %PelvisAccel.Z(start_HS1:end_HS1) TorsoAccel.Z(start_HS1:end_HS1)];
%output = [PelvisAccel.X(start_HS1:end_HS1) TorsoAccel.X(start_HS1:end_HS1)];


end

