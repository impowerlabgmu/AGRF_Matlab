%Notes to work on for 7/27

%% The Foot-ground-contact detection has been outlined by Kim https://www.tandfonline.com/doi/full/10.1080/00140139.2016.1174314
%       This method relies on a lot of data, so maybe not the best

%% I would like to use the onset of GRFs as a target (When the HS starts),
%and the shank acceleration and hip angle as predictors.

%% I also should run the model with interaction terms instead of the vertical
%accelerations

%% Need to go back into the script that creates "AllData.mat" and add in the
%foot position and implement it (alongside velocity) to get the correct
%leg.

%% Look into the ML techniques that are already available in MATLAB. Compile a list
% of these and sort through which should be used for this porject. A
% direction is very important to have for next week.

%% Use participant 10 to figure out why we're getting some NaNs and [0,0,0,0,0]s 
% for the coefficients

scatter(G(:,1),G(:,2))
ylim([0.6 1])
xlabel('Walking Speed (m/s)')
ylabel('R-Squared')


%% Currently, We start by the get the raw data and put it in the Extract relevant data (ExtractTrialData)
% Then, we put it in sheet format (CrerateDataStructs)
%       This is where we will have to filter the GRFs, and clip the trials
%       (both the force data and the motion data) - find a step where this
%       can be done at the same time without passing the data back and
%       forth
% 

% After the visualFS check, save current time frames and secondary time
% frames. Then convert to XSens time frames after this.


