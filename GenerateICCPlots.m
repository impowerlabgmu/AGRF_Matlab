%GenerateICCPlots

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



hold on

BallSize = increment/12;

make_ballgraph([0 0.5*increment],UB_Prop_U,LB_Prop_U,ICC_Prop_U,'blue',BallSize,2)
make_ballgraph([0.5*increment 1*increment],UB_Brake_U,LB_Brake_U,ICC_Brake_U,'red',BallSize,2)


make_ballgraph([1.5*increment 2*increment],UB_Prop_W,LB_Prop_W,ICC_Prop_W,'blue',BallSize,2)
make_ballgraph([2*increment 2.5*increment],UB_Brake_W,LB_Brake_W,ICC_Brake_W,'red',BallSize,2)

h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-b','LineWidth',2);
h(2) = plot(NaN,NaN,'-r','LineWidth',2);

ylim([-0.1 1])

pbaspect([1 1 1])

hold off


%Create Legend

legend(h,'Propulsion force', 'Braking Force');
legend boxoff

x_ticks=[0.5*increment,2*increment];

ticklabels= {'Unweighted Model'; 'Weighted Model'};

set(gca,'XTick',x_ticks)
set(gca,'XTickLabels',ticklabels)
set(gca,'fontname','Avant Garde')
set(gca,'fontsize',24)
set(gca,'fontweight','bold')

title('ICC Values with Associated Confidence Intervals')






function make_ballgraph(frame, UB, LB, Middle,color,ballRadius,linewidth)
midpoint = mean(frame);
circle(midpoint,Middle,ballRadius,color,linewidth); %make the middle circle
verticalLine(LB,Middle-ballRadius,midpoint,color,linewidth) %make the bottom line
horizLine(midpoint-ballRadius/2,midpoint+ballRadius/2,LB,color,linewidth)
horizLine(midpoint-ballRadius/2,midpoint+ballRadius/2,UB,color,linewidth)
verticalLine(Middle+ballRadius,UB,midpoint,color,linewidth) %make the bottom line
end

function verticalLine(bottom,top,location,color,linewidth)
plot([location location],[bottom top],'Color',color,'LineWidth',linewidth);
end


function circle(x,y,r,color,linewidth)
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
plot(xunit, yunit,'Color',color,'LineWidth',linewidth);
end

function horizLine(left,right,height,color,linewidth)
plot([left right],[height height],'Color',color,'LineWidth',linewidth)
end
