%%Create MAT files for Vicon and XSens Data

%%Vicon (Forceplate Data)
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


for k = 1%:10%length(subFolderNames)
    tic
    currDir = [subFolder_Prefix{1} '\' subFolderNames{k}];
    cd(currDir)

    subFolderFiles = dir(currDir);

    for j = 1:length(subFolderFiles)
        try
            if contains(subFolderFiles(j).name,'.csv')
%                 [FPData,FPFrameRate] = Import_ViconFP(subFolderFiles(j).name);
%                 savename = ['P' subFolderFiles(j).name(5:end-4) '_FP.mat'];
%                 save(savename,'FPData','FPFrameRate')
            elseif contains(subFolderFiles(j).name,'.xlsx')
                [XSensData,DataNames] = Import_XSens(subFolderFiles(j).name);
                x = split(subFolderFiles(j).name,'-');
                savename = ['P' x{1}(3:end-2) x{2}(2:end-5) '_IMU.mat'];
                save(savename,'XSensData','DataNames')
            end
        catch
            disp([subFolderFiles(j).name ' needs to be fixed.'])
        end
    end
    toc
end






