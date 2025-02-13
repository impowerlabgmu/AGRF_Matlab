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

for k = 1:length(subFolderNames)

    currDir = [subFolder_Prefix{1} '\' subFolderNames{k}];
    cd(currDir)

    d = currDir;

    PIDPath = split(d,'\');
    PID = PIDPath{end};
    PIDnum = PID(end-1:end);

    CurrPP = eval(['PP' PIDnum]);

    %% Get Results for current participant and get subject-specific coefficients
    currResults = ['AGRF0' PIDnum '_Results.mat'];

    load(currResults)

    id = find(~any(Coeffs,2));
    Coeffs(id,:) = [];

    AvgCoeffs = mean(Coeffs,1);

    
    %% Get the list of files for this participant
    SSDataFiles = dir(fullfile(d, 'AGRF*SS*.mat'));
    SlowDataFiles = dir(fullfile(d, 'AGRF*Slow*.mat'));
    FastDataFiles = dir(fullfile(d, 'AGRF*Fast*.mat'));

    for i = 2:length(SSDataFiles)
        DataFilename = [SSDataFiles(1).folder '\' SSDataFiles(i).name];
        load(DataFilename)
        try
            RSquaredNewSS(i) = Calc_RSquared(AvgCoeffs,X,y);
            disp([currResults ' processed successfully.']);
        catch
            disp([currResults ' did not process.']);
        end
    end
    
    for i = 1:length(SlowDataFiles)
        DataFilename = [SlowDataFiles(1).folder '\' SlowDataFiles(i).name];
        load(DataFilename)
        try
            RSquaredNewSlow(i) = Calc_RSquared(AvgCoeffs,X,y);
            disp([currResults ' processed successfully.']);
        catch
            disp([currResults ' did not process.']);
        end
    end
    
    for i = 1:length(FastDataFiles)
        DataFilename = [FastDataFiles(1).folder '\' FastDataFiles(i).name];
        load(DataFilename)
        try
            RSquaredFast(i) = Calc_RSquared(AvgCoeffs,X,y);
            disp([currResults ' processed successfully.']);
        catch
            disp([currResults ' did not process.']);
        end
    end
    
end