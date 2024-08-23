%%Add Data to FP.mat files to include foot strike frames, total frames,
%%direction, total frames

clear
clc

topLevelFolder = 'M:\mydata\MATLAB_Data\Wearable Sesnors GRF\Pilot Data\AGRF Pilot Export';

%topLevelFolder = uigetdir(pwd, 'Select a folder');
files = dir(topLevelFolder);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
subFolderNames = {subFolders(3:end).name};
subFolder_Prefix = {subFolders(1).folder};


for k = 1:length(subFolderNames)
    tic
    currDir = [subFolder_Prefix{1} '\' subFolderNames{k}];
    cd(currDir)

    subFolderFiles = dir(currDir);

    for j = 1:length(subFolderFiles)
%         try
            if contains(subFolderFiles(j).name,'FP.mat')
                load(subFolderFiles(j).name);
                FP_Total_Frames = length(FPData.FP1_F);
                direction = DetermineFPDirection(FPData);
                DataFrames = TargetFrames(FPData);
                save(subFolderFiles(j).name,'FPData','FPFrameRate','FP_Total_Frames','direction','DataFrames');
            elseif contains(subFolderFiles(j).name,'IMU.mat')
                load(subFolderFiles(j).name)
                [XSensFrames, Velocity, XSensDirection] = getSpeed(XSensData);
                [TorsoAccel,PelvisAccel,JAngles] = ExtractXSens(XSensData);
%                 [FWDFoot] = findLegStrike(XSensData,XSensDirection);
                save(subFolderFiles(j).name,'XSensData','DataNames','XSensFrames','TorsoAccel','PelvisAccel','JAngles','Velocity','XSensDirection');
            end
%         catch
%             disp([subFolderFiles(j).name 'could not be processed'])
%         end
    end
    toc
end


function direction = DetermineFPDirection(ForcePlateData)
    FtotY = ForcePlateData.FP1_F(:,2)+ ForcePlateData.FP2_F(:,2)+ForcePlateData.FP3_F(:,2)+ForcePlateData.FP4_F(:,2);
    [~,maxidx] = max(FtotY); [~,minidx] = min(FtotY);

    if maxidx > minidx
        direction = 1;
    elseif minidx > maxidx
        direction = -1;
    else
        direction = 0;
    end
end

function nonzeroFrames = TargetFrames(ForcePlateData)
    FtotY = ForcePlateData.FP1_F(:,2)+ ForcePlateData.FP2_F(:,2)+ForcePlateData.FP3_F(:,2)+ForcePlateData.FP4_F(:,2);
    
    FtotY(abs(FtotY)<10) = 0;

    if all(FtotY == 0)
        nonzeroFrames = [0 0];
    else
        nZF = find(abs(FtotY)>0);
        nonzeroFrames = [nZF(1),nZF(end)];
    end
   

end

function [Frames, Velocity, XSENSdirection] = getSpeed(XSensData)
    PosData = XSensData{1,5}(:,2);
    VelArray = diff(PosData{:,1}).*100;
    Velocity = mean(VelArray);
    XSENSdirection = Velocity/abs(Velocity);
    Frames = length(VelArray) + 1;
end

function [TorsoAccel, PelvisAccel, JAngles] = ExtractXSens(XSensData)
    TorsoAccel.X = table2array(XSensData{1,7}(:,14));
    TorsoAccel.Y = table2array(XSensData{1,7}(:,15));
    TorsoAccel.Z = table2array(XSensData{1,7}(:,16));

    PelvisAccel.X = table2array(XSensData{1,7}(:,2));
    PelvisAccel.Y = table2array(XSensData{1,7}(:,3));
    PelvisAccel.Z = table2array(XSensData{1,7}(:,4));

    JAngles.RHip = table2array(XSensData{1,10}(:,44:46));
    JAngles.RKnee = table2array(XSensData{1,10}(:,47:49));
    JAngles.LHip = table2array(XSensData{1,10}(:,56:58));
    JAngles.LKnee = table2array(XSensData{1,10}(:,59:61));
end

function [FWDFoot] = findLegStrike(XSensData,XSensDirection)
    RFootData = table2array(XSensData{1,5}(:,53));
    LFootData = table2array(XSensData{1,5}(:,68));
    Greater = gt(RFootData,LFootData);
    if XSensDirection == 1
        FWDFoot(Greater == 0) = 'L';
        FWDFoot(Greater == 1) = 'R';
    elseif XSensDirection == -1
        FWDFoot(Greater == 1) = 'L';
        FWDFoot(Greater == 0) = 'R';
    end
end





