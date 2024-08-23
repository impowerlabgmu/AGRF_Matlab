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

tic
for k = 1:length(subFolderNames)
    currDir = [subFolder_Prefix{1} '\' subFolderNames{k}];
    cd(currDir)

    subFolderFiles = dir(currDir);
    countFP = 1;
    countIMU = 1;
    CellDataTypesFP = {'Data','TrialType','TrialNumber','DataFrames','Direction','Heelstrike Frames'};
    CellDataTypesIMU = {'Data','TrialType','TrialNumber','DataFrames','Direction','Velocity','LegStrike'};

    for j = 1:length(subFolderFiles)
        if contains(subFolderFiles(j).name,'.mat')
            try
                load(subFolderFiles(j).name)
                x = split(subFolderFiles(j).name,'_');
                PID = x{1};
                TrialType = x{2};
                TrialNumber = x{3};
                DataType = x{4}(1:end-4);

                if contains(subFolderFiles(j).name,'FP.mat')
                    KeyData = DataFrames;
                    Data = ExtractFPData(FPData);
                    Direction = direction;
                    NumFrames = FP_Total_Frames;

                    ForceData{countFP,1,k} = Data;
                    ForceData{countFP,2,k} = TrialType;
                    ForceData{countFP,3,k} = TrialNumber;
                    ForceData{countFP,4,k} = NumFrames;
                    ForceData{countFP,5,k} = Direction;
                    ForceData{countFP,6,k} = KeyData;

                    countFP = countFP + 1;

                elseif contains(subFolderFiles(j).name,'IMU.mat')
                    Data = {JAngles PelvisAccel TorsoAccel};
                    Direction = XSensDirection;
                    NumFrames = XSensFrames;
                    KeyData = Velocity; %KeyData is Velocity for IMU and the heelstrikes for FP

                    MotionData{countIMU,1,k} = Data;
                    MotionData{countIMU,2,k} = TrialType;
                    MotionData{countIMU,3,k} = TrialNumber;
                    MotionData{countIMU,4,k} = NumFrames;
                    MotionData{countIMU,5,k} = Direction;
                    MotionData{countIMU,6,k} = KeyData;
                    %MotionData{countIMU,7,k} = FWDFoot;

                    countIMU = countIMU + 1;
                end
            catch
                disp([subFolderFiles(j).name ' could not be processed'])
            end
        end
    end
end

toc
saveFolder = 'M:\mydata\MATLAB_Data\Wearable Sesnors GRF\Pilot Data\Processing Scripts';
cd(saveFolder)
save('NewData.mat','MotionData','ForceData')

function ExtractedData = ExtractFPData(FPData)

ExtractedData{1} = FPData.FP1_F;
ExtractedData{2} = FPData.FP2_F;
ExtractedData{3} = FPData.FP3_F;
ExtractedData{4} = FPData.FP4_F;

end


