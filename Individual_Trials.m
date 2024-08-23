%% Summarize the Results of individual-trial models

%Edited 1/8/2023

clear
clc

load('NewData_v3.mat')
load('CollectionInfoUPD.mat')
load('MatchedTrials_v4.mat')

j = 10;

count2 = 1;

FullCoeffs = []; stringID = [];

weighting_on = 0; %1 turns weighting on, 0 turns it off
max_weighting_factor = 10; % Adds a 10% weighting factor to max points
min_weighting_factor = 10; % Adds a 10% weighting factor to min points

for sheet = 1:j

    tempID = [];
%     figure
    count = 1;
    
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

%     InputDataTemp = [];
%     OutputDataTemp = [];
 
    for trial = 1:length(FinalMatches{sheet})
        Mapping = FinalMatches{sheet};
        trialnumIMU = Mapping(trial,1);
        trialnumFP = Mapping(trial,2);
        
%         pause
        try

            if CurrPP.Leg{trialnumIMU} == 0 || ~any(SheetFP{trial,6})
                continue
            end

            [X,Samp] = GetMotionData(SheetMot{trialnumIMU,7},SheetMot{trialnumIMU,1},SheetFP{trialnumFP,7});
            % X = [ones(size(X(:,1)))*SheetMot{trialnumIMU,6} X];
            X = [ones(size(X(:,1))) X];

            [y, FP1,FP2,FP3,FP4] = GetForceData(SheetFP{trialnumFP,9},SheetFP{trialnumFP,1},SheetFP{trialnumFP,5},Samp,mass);
            VisualInspect(trial) = 1;

            if weighting_on == 1
                [X_Weight, yWeight] = AddWeighting(X,y,min_weighting_factor,max_weighting_factor);
                X = X_Weight;
                y = yWeight;
            end

            

            tempCoeff = regress(y,X)';
            TC(count,:) = tempCoeff;

            [RSquared{count,sheet},MaxR,MinR] = Calc_RSquared(tempCoeff,X,y,0);
            Cell_plot{count,1} = tempCoeff*X';
            Cell_plot{count,2} = y;

            ICCDataMax{sheet}(count,1:2) = [max(y), MaxR];
            ICCDataMin{sheet}(count,1:2) = [min(y), MinR];

            tempRS = RSquared{count,sheet};

%             pause

%             for i = 1:r
%                 X_temp = X(:,combinations(i,:));
%                 Coeffs_temp = regress(y,X_temp);
%                 RSquared_Opt(i,count) = Calc_RSquared(Coeffs_temp',X_temp,y);
%             end

            if tempRS > 0
                ScatterData(count2,1:3) = [abs(SheetMot{trialnumIMU,6}), tempRS, sheet];
%             else
%                 disp('too low')
%                 pause
                count2 = count2+1;
            end

            tempID = [tempID; string(SheetFP{trialnumFP,2})];


            Vel = abs(SheetMot{trialnumIMU,6});
            Speed = Vel*ones(size(y));
            PID = sheet*ones(size(y));
            XOut = [X Speed PID];

            InputData{sheet,count} = XOut;
            OutputData{sheet,count} = y;

            count = count + 1;


        catch
            VisualInspect(trial) = 0;
        end
    end
    
    [r,c] = size(TC);
    id = ones(r,1)*sheet;

    Coeffs{sheet} = [TC];

    TC = [TC id];

    stringID = [stringID; tempID];

    FullCoeffs = [FullCoeffs; TC];

    ReviewTrials{sheet} = VisualInspect;
    numBadTrials(sheet) = sum(VisualInspect);
    numGoodTrials(sheet) = length(VisualInspect) - numBadTrials(sheet);

%     InputData{sheet} = InputDataTemp;
%     OutputData{sheet} = OutputDataTemp;

end

[r2,c2] = size(FullCoeffs); c2 = c2+3;

% s2 = str2num(stringID);

G = ScatterData(any(ScatterData,2),:);

T = table('Size',[r2,c2],'VariableNames',{'C0','C1','C2','C3','C4','PID','Condition','RSquared','Speed'},'VariableTypes',{'double','double','double','double','double','categorical','categorical','double','double'});
T.C0 = FullCoeffs(:,1); T.C1 = FullCoeffs(:,2); T.C2 = FullCoeffs(:,3); T.C3 = FullCoeffs(:,4); T.C4 = FullCoeffs(:,5);
T.PID = categorical(FullCoeffs(:,6)); T.Condition = categorical(stringID); T.RSquared = G(:,2); T.Speed = G(:,1);


TFast = T(T.Condition == 'Fast',:);
TSS = T(T.Condition == 'SS',:);
TSlow = T(T.Condition == 'Slow',:);


PID1 = T(T.PID == '1',:);
PID2 = T(T.PID == '2',:);
PID3 = T(T.PID == '3',:);
PID4 = T(T.PID == '4',:);
PID5 = T(T.PID == '5',:);
PID6 = T(T.PID == '6',:);
PID7 = T(T.PID == '7',:);
PID8 = T(T.PID == '8',:);
PID9 = T(T.PID == '9',:);
PID10 = T(T.PID == '10',:);

ICCMin = cellfun(@corrcoef, ICCDataMin,'UniformOutput',false);
ICCMax = cellfun(@corrcoef, ICCDataMax,'UniformOutput',false);

for v = 1:10
    ICCMinFinal(v,1) = abs(ICCMin{v}(1,2));
    ICCMaxFinal(v,1) = abs(ICCMax{v}(1,2));
end

%CompareReconstructedToOriginal

% figure
% t = tiledlayout(2,5);
% 
% for v = 1:10
%     nexttile
%     eval(['Data = PID' num2str(v) ';']);
%     boxplot([Data.C0 Data.C1 Data.C2 Data.C3 Data.C4])
% %     boxplot([Data.C1 Data.C2 Data.C3 Data.C4])
%     ylim([-2 2])
%     eval(['title("Participant ' num2str(v) '")']);
% end
% 
% title(t,'Regression Coefficients by Participant')


% scatter(T,'PID','RSquared')
% scatter(T,'Condition','RSquared')

% close all

% boxplot([FullCoeffs(:,2) FullCoeffs(:,3) FullCoeffs(:,4) FullCoeffs(:,5)])
% scatter(G(:,2),FullCoeffs(:,1))
% scatter(G(:,2),FullCoeffs(:,2))
% scatter(G(:,2),FullCoeffs(:,3))
% scatter(G(:,2),FullCoeffs(:,4))
% scatter(G(:,2),FullCoeffs(:,5))
% save('FullCoefficients_Weighted.mat','FullCoeffs','T')
save('FullCoefficients.mat','FullCoeffs','T')


% scatter(G(:,1),G(:,2))
% ylim([0.7 1])
% xlim([0.75 2.25])
% title('100 ms Moving Average Filter (Real-time Approximation)')
% xlabel('Walking Speed (m/s)')
% ylabel('R-Squared')
% 
% mean(G(:,2))
% std(G(:,2))

% boxplot(TotRSquared);
% meanR2 = mean(TotRSquared);
% stdR2 = std(TotRSquared);



function [XWeighted, yWeighted] = AddWeighting(X,y,weightmin,weightmax)

[val_min, idx_min] = min(y); Xmin = X(idx_min,:);
[val_max, idx_max] = max(y); Xmax = X(idx_max,:);

size_min_add = ceil((weightmin/100)*length(y));
size_max_add = ceil((weightmax/100)*length(y));

min_add = repmat(val_min,size_min_add,1);
max_add = repmat(val_max,size_max_add,1);
Xmin_add = repmat(Xmin,size_min_add,1);
Xmax_add = repmat(Xmax,size_max_add,1);

XWeighted = [X;Xmin_add;Xmax_add];
yWeighted = [y;min_add;max_add];

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

Toutput = (output/(mass*9.81))*direction;

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
window_size = 5;

B = 1/window_size*ones(window_size,1);
Hip = filter(B,1,Hip);
Knee = filter(B,1,Knee);

window_size_Accel = 1;
B = 1/window_size_Accel*ones(window_size_Accel,1);
PelvisAccel.X = filter(B,1,PelvisAccel.X);
TorsoAccel.X = filter(B,1,TorsoAccel.X);



Samples = (start_HS1:end_HS1)*10;


%output = [sind(Hip) sind(Knee) PelvisAccel.X(start_HS1:end_HS1) TorsoAccel.X(start_HS1:end_HS1)]; %PelvisAccel.Z(start_HS1:end_HS1) TorsoAccel.Z(start_HS1:end_HS1)];
output = [(Hip) (Knee) PelvisAccel.X(start_HS1:end_HS1) TorsoAccel.X(start_HS1:end_HS1)]; %PelvisAccel.Z(start_HS1:end_HS1) TorsoAccel.Z(start_HS1:end_HS1)];
%output = [PelvisAccel.X(start_HS1:end_HS1) TorsoAccel.X(start_HS1:end_HS1)];


end


