
% Check the number of trials in all of the file list

clear
clc

load('CollectionInfo.mat')

%topLevelFolder = uigetdir(pwd, 'Select a folder');
topLevelFolder = 'C:\Users\glove\OneDrive - The Ohio State University\Documents\MATLAB\GMU\Wearable Sesnors GRF\Pilot Data\AGRF Pilot Export';

files = dir(topLevelFolder);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
subFolderNames = {subFolders(3:end).name};
subFolder_Prefix = {subFolders(1).folder};

for k = 9%:length(subFolderNames)

    currDir = [subFolder_Prefix{1} '\' subFolderNames{k}];
    cd(currDir)

    d = currDir;

    PIDPath = split(d,'\');
    PID = PIDPath{end};
    PIDnum = PID(end-1:end);

    CurrPP = eval(['PP' PIDnum]);

    VicFiluigetdires = dir(fullfile(d, '*.csv'));
    XSensFiles = dir(fullfile(d, '*.xlsx'));

    XSens_Prefix = ['PP0' PIDnum];
    Vicon_Prefix = [PID];

    mass = CurrPP.mass;

    SSidx = find(contains(CurrPP.TrialType,'SS'));
    Slowidx = find(contains(CurrPP.TrialType,'Slow'));
    Fastidx = find(contains(CurrPP.TrialType,'Fast'));

    VicSSFiles = dir(fullfile(d, '*SS_*.csv'));
    XSensSSFiles = dir(fullfile(d, '*SS_*.xlsx'));

    differenceSS = GetDiff(XSensSSFiles,VicSSFiles);



end



function difference = GetDiff(XSensFiles,ViconFiles)

    for i = 1:length(ViconFiles)

        [FPData,FPFrameRate] = Import_ViconFP(ViconFiles(i).name);

        AAVicon(i) = length(FPData.FP4_F);
    end

    for j = 1:length(XSensFiles)
        try
            [XSensData,DataNames] = Import_XSens(XSensFiles(j).name);
            AAXSens(j) = height(XSensData{3});
        catch
           Z = sprintf('There is an issue with %s',XSensFiles(j).name);
           disp(Z);
           AAXSens(j) = 0;
        end
    end

    AAVicon = fix(AAVicon/10)';
    AAXSens = AAXSens';

    
    try
        difference = AAXSens - AAVicon;
    catch
       lengthDiff = length(AAXSens) - length(AAVicon);
       AAVicon(end+1:end+lengthDiff) = 0;
       
 

       function shift_length = Shift_Num(AAXSens,AAVicon)
           diffTemp = AAXSens - AAVicon;
           IDX = find(abs(diffTemp) > 5);
           if length(IDX) > 1
               Consecutive = diff(IDX);
               

           end
    end




       




end

