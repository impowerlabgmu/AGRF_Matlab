%Run full data import

function [Coeffs,RSquared] = GenerateViconFPandXSensMatFiles(ViconFname,XSensFname,FPID,mass,Leg)


[FPData,FPFrameRate] = Import_ViconFP(ViconFname);
[XSensData,DataNames] = Import_XSens(XSensFname);


    if FPID == 4
        Total_Force = FPData.FP4_F;
    elseif FPID == 1
        Total_Force = FPData.FP1_F;
    elseif FPID == 2
        Total_Force = FPData.FP2_F;
    elseif FPID == 3
        Total_Force = FPData.FP3_F;
    elseif FPID == 12
        Total_Force = FPData.FP1_F + FPData.FP2_F;
    elseif FPID == 23
        Total_Force = FPData.FP2_F + FPData.FP3_F;
    end


AAVicon = length(Total_Force);
AAXSens = height(XSensData{3});


Total_Force(abs(Total_Force)<3.5) = 0;


%Detect Heelstrikes from FP
Tot_Fz = Total_Force(:,3);
Tot_Fz(abs(Tot_Fz)<10) = 0;

idx = find(abs(Tot_Fz)>0);
D_idx = diff(idx);

idx(D_idx>1) = [];
startidx = idx(1); endidx = idx(end);

%Identify clean heelstrike
FP_HS = Total_Force(startidx:endidx,3);
Total_Force(abs(FP_HS)<10) = 0;
idxHS = find(abs(FP_HS)>0);
D_idxHS = diff(idxHS);
idx(D_idxHS>1) = [];
startidxHS = idxHS(1); endidxHS = idxHS(end);

startidxHS = startidxHS + startidx - 1;
endidxHS = endidxHS + endidx - 1;

startidxHS1_XSens = fix((startidxHS/FPFrameRate)*100);
endidxHS1_XSens = fix((endidxHS/FPFrameRate)*100);

XSensSamples = [startidxHS1_XSens:endidxHS1_XSens];
FPSamples = fix((XSensSamples./100).*FPFrameRate);

%Get Force Plate Data
FP.X = Total_Force(FPSamples,1)./mass;
FP.Y = Total_Force(FPSamples,2)./mass;
FP.Z = Total_Force(FPSamples,3)./mass;

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
x = split(ViconFname,'_');
savename = [x{1},'_',x{2},'_',x{3}(1:2),'.mat'];
%savename_JA = [x{1},'_',x{2},'_',x{3}(1:2),'JointAngles.mat'];
%save(savename,'RULAngles','LULAngles','RLLAngles','LLLAngles','TorsoAccel',"PelvisAccel","PelvisAngles",'FP')
%save(savename_JA,'RHip','LHip','RKnee','LKnee','RAnkle',"LAnkle","TorsoAccel",'PelvisAccel','FP')


%% Run regression analysis to find 
if Leg == 'L'
    Hip = LHip; Knee = LKnee; Ankle = LAnkle;
else
    Hip = RHip; Knee = RKnee; Ankle = RAnkle;
end

y = FP.Y;
ymax = max(y); ymin = min(y);

goodTime = find(diff(y) ~= 0);

y = y(goodTime);

[ymax, ymaxtime] = max(y);
[ymin, ymintime] = min(y);

if ymintime > ymaxtime
    y = -y;
end

X = [sin(Hip(goodTime,3)) sin(Knee(goodTime,3)) TorsoAccel.X(goodTime) PelvisAccel.X(goodTime)];

[b,bint,r,rint,stats] = regress(y,X);
RSquared = stats(1);

Coeffs = b;

save(savename,'X','y','Coeffs')

function [Angles] = QuatArray2Angles(QuatArray)
Quat = quaternion(QuatArray(:,1),QuatArray(:,2),QuatArray(:,3),QuatArray(:,4));
Angles = eulerd(Quat,'ZXY','point');

end






end