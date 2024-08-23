%Run Data import

%Edited 11/16/2023 - NAG
tic

clear
clc

% load('CollectionInfo.mat')

load('FullCoefficients.mat')

%topLevelFolder = uigetdir(pwd, 'Select a folder');
%topLevelFolder = 'C:\Users\glove\OneDrive - The Ohio State University\Documents\MATLAB\GMU\Wearable Sesnors GRF\Pilot Data\AGRF Pilot Export';
topLevelFolder = 'M:\mydata\MATLAB_Data\Wearable Sesnors GRF\Pilot Data\AGRF Pilot Export';


files = dir(topLevelFolder);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
subFolderNames = {subFolders(3:end).name};
subFolder_Prefix = {subFolders(1).folder};

for k = 1:length(subFolderNames)

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

    for i = 1:length(CurrPP.TrialType)
        XSensfilename = [XSens_Prefix '_' CurrPP.TrialType{i} '_01-0' CurrPP.TrialNum{i} '.xlsx'];
        Viconfilename = [Vicon_Prefix '_' CurrPP.TrialType{i} '_' CurrPP.TrialNum{i} '.csv'];
        LegStrike = CurrPP.Leg{i};
        try
            [Coeffs(i,:), RSquared(i)] = GenerateViconFPandXSensMatFiles(Viconfilename,XSensfilename,CurrPP.FP(i),mass,LegStrike);
            disp([Vicon_Prefix '_' CurrPP.TrialType{i} '_' CurrPP.TrialNum{i} ' processed successfully.']);
        catch
            disp([Vicon_Prefix '_' CurrPP.TrialType{i} '_' CurrPP.TrialNum{i} ' did not process.']);
        end
    end

    sname = [Vicon_Prefix '_Results.mat'];
    save(sname, 'Coeffs', 'RSquared');

end
toc