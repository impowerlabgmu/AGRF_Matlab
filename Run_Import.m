clear
clc

[FPData,FPFrameRate] = Import_ViconFP('Pilot00103.csv');
[XSensData,DataNames] = Import_XSens('Trial Session1_Sanders_LowerBody-003.xlsx');

Total_Force = FPData.FP1_F + FPData.FP2_F + FPData.FP3_F + FPData.FP4_F;

Total_Force(abs(Total_Force)<3.5) = 0;

%Detect Heelstrikes from FP
Tot_Fz = FPData.FP1_F(:,3) + FPData.FP2_F(:,3) + FPData.FP3_F(:,3) + FPData.FP4_F(:,3);
Tot_Fz(abs(Tot_Fz)<10) = 0;

idx = find(abs(Tot_Fz)>0);
D_idx = diff(idx);

idx(D_idx>1) = [];

startidx = idx(1); endidx = idx(end);

%For this trial, there is a clean heelstrike on FP1 first
FP1_HS = FPData.FP1_F(startidx:endidx,3);
FP1_HS(abs(FP1_HS)<10) = 0;
idxHS1 = find(abs(FP1_HS)>0);
D_idxHS1 = diff(idxHS1);
idx(D_idxHS1>1) = [];
startidxHS1 = idxHS1(1); endidxHS1 = idxHS1(end);

startidxHS1 = startidxHS1 + startidx - 1;
endidxHS1 = endidxHS1 + endidx - 1;

startidxHS1_XSens = fix((startidxHS1/FPFrameRate)*100);
endidxHS1_XSens = fix((endidxHS1/FPFrameRate)*100);

XSensSamples = [startidxHS1_XSens:endidxHS1_XSens];
FPSamples = (XSensSamples./100).*FPFrameRate;

%Get Force Plate Data
FP.X = FPData.FP1_F(FPSamples,1);
FP.Y = FPData.FP1_F(FPSamples,2);
FP.Z = FPData.FP1_F(FPSamples,3);

%Get the XSens Data
%COM Acceleration
TorsoAccel.X = table2array(XSensData{1,7}(XSensSamples,14));
TorsoAccel.Y = table2array(XSensData{1,7}(XSensSamples,15));
TorsoAccel.Z = table2array(XSensData{1,7}(XSensSamples,16));

PelvisAccel.X = table2array(XSensData{1,7}(XSensSamples,2));
PelvisAccel.Y = table2array(XSensData{1,7}(XSensSamples,3));
PelvisAccel.Z = table2array(XSensData{1,7}(XSensSamples,4));

%Segment Quaternions -> Angles
RULQuatArray = table2array(XSensData{1,3}(XSensSamples,62:65));
RULAngles = QuatArray2Angles(RULQuatArray);

RLLQuatArray = table2array(XSensData{1,3}(XSensSamples,66:69));
RLLAngles = QuatArray2Angles(RLLQuatArray);

LULQuatArray = table2array(XSensData{1,3}(XSensSamples,78:81)); 
LULAngles = QuatArray2Angles(LULQuatArray);

LLLQuatArray = table2array(XSensData{1,3}(XSensSamples,82:85)); 
LLLAngles = QuatArray2Angles(LLLQuatArray);

PelvisQuatArray = table2array(XSensData{1,3}(XSensSamples,2:5)); 
PelvisAngles = QuatArray2Angles(PelvisQuatArray);

%Joint angles - Calculated by Awinda
RHip = table2array(XSensData{1,10}(XSensSamples,44:46));

RKnee = table2array(XSensData{1,10}(XSensSamples,47:49));

RAnkle = table2array(XSensData{1,10}(XSensSamples,50:52)); 

LHip = table2array(XSensData{1,10}(XSensSamples,56:58));

LKnee = table2array(XSensData{1,10}(XSensSamples,59:61));

LAnkle = table2array(XSensData{1,10}(XSensSamples,62:64));


%Save Arrays of interest
save('003Data.mat','RULAngles','LULAngles','RLLAngles','LLLAngles','TorsoAccel',"PelvisAccel","PelvisAngles",'FP')
save('003Data_JointAngles.mat','RHip','LHip','RKnee','LKnee','RAnkle',"LAnkle","TorsoAccel",'PelvisAccel','FP')

%Perform Regression at each Data Point

 
function [Angles] = QuatArray2Angles(QuatArray)

Quat = quaternion(QuatArray(:,1),QuatArray(:,2),QuatArray(:,3),QuatArray(:,4));
Angles = eulerd(Quat,'ZXY','point');

end

