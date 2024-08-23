
clear
clc

load('ICCData_UnWeighted.mat')

Prop_U = ICCMaxTot;
ICC_Prop_U = ICC(Prop_U,'A-1');
Brake_U = ICCMinTot; 
ICC_Brake_U = ICC(Brake_U,'A-1');

[~, LB_Prop_U, UB_Prop_U, ~, ~, ~, ~] = ICC(Prop_U,'A-1');
[~, LB_Brake_U, UB_Brake_U, ~, ~, ~, ~] = ICC(Brake_U,'A-1');



load('ICCData_Weighted.mat')

Prop_W = ICCMaxTot; Prop_W(2:end,2) = Prop_W(2:end,2)*9.81;
ICC_Prop_W = 0.7924;% abs(ICC(Prop_W,'A-1'));
Brake_W = ICCMinTot; Brake_W(2:end,2) = Brake_W(2:end,2)*9.81;
ICC_Brake_W = 0.8672;%abs(ICC(Brake_W,'A-1'));

%[~, LB_Prop_W, UB_Prop_W, ~, ~, ~, ~] = ICC(Prop_W,'A-1');
%[~, LB_Brake_W, UB_Brake_W, ~, ~, ~, ~] = ICC(Brake_W,'A-1');
LB_Prop_W = 0.543;
UB_Prop_W = 0.830;
LB_Brake_W = 0.256;
UB_Brake_W = 0.9450;


totalmax = max([UB_Brake_W,UB_Prop_W,UB_Brake_U,UB_Prop_U]);
totalmin = min([LB_Brake_W,LB_Prop_W,LB_Brake_U,LB_Prop_U]);

aspectRatio = [totalmin totalmax];
range = 1.1;%totalmax-totalmin;
increment = range/3;

MDCProp = 0.11;
MDCBrake = 0.14;


hold on

% Data = R2Data; Target = 0.9;
Data = RMSEData; Target = 0.1;



for i = 1:length(Data)
    Target = [Target, Data{i}];
end

mean(Target)
std(Target)
