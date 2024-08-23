clear
clc
close all

load('ICCData_UnWeighted.mat')

Err_Prop_U  = abs(ICCMaxTot(:,1) - ICCMaxTot(:,2))/9.81;
Err_Brake_U = abs(ICCMinTot(:,1) - ICCMinTot(:,2))/9.81;


load('ICCData_Weighted.mat')

ICCMaxTot(2:end,2) = ICCMaxTot(2:end,2)*9.81;
ICCMinTot(2:end,2) = ICCMinTot(2:end,2)*9.81;

Err_Prop_W  = abs(ICCMaxTot(:,1) - ICCMaxTot(:,2))/9.81;
Err_Brake_W = abs(ICCMinTot(:,1) - ICCMinTot(:,2))/9.81;

MDCProp = getMDC(ICCMaxTot);
MDCBrake = getMDC(ICCMinTot);

% NanVec = nan(length(Err_Brake_W),1);

BoxChartData = [Err_Brake_U,Err_Brake_W,Err_Prop_U,Err_Prop_W];


namingOrder = ["Brake Error","Prop Error"];

[minD,maxD,meanD,Q1,Q3] = getStats(Err_Brake_U);


[r,c] = size(BoxChartData);
range = 0.35;
increment = range/c;

Colors = ["blue";"red";"blue";"red"];
linewidth = 2;


hold on
for i = 1:c
    [minD,maxD,meanD,Q1,Q3] = getStats(BoxChartData(2:end,i));
    if i < 3
        H = i-0.5;
    else
        H = i;
    end
    padding = 0.2;
    frame = [(H*increment)+padding*increment ((H+1)*increment)-padding*increment];
    make_boxchart(frame,maxD,minD,Q1,Q3,meanD,Colors(i),0.1,linewidth)
end

ylim([-0.01 0.16])

h = zeros(2, 1);
h(1) = plot(NaN,NaN,'-b','LineWidth',linewidth);
h(2) = plot(NaN,NaN,'-r','LineWidth',linewidth);

pbaspect([1 1 1])

plot([0.5*increment 2.5*increment],[MDCBrake MDCBrake],'--k','LineWidth',linewidth+1)
plot([3*increment 5*increment],[MDCProp MDCProp],'--k','LineWidth',linewidth+1)

hold off


title('Absolute Error Relative to MDC')

ylabel('Error (BW)')

legend(h,'Unweighted Model', 'Weighted Model','Location','northwest')
legend boxoff

x_ticks=[1.5*increment,4*increment];

ticklabels= {'Brake Error'; 'Propulsion Error'};

set(gca,'XTick',x_ticks)
set(gca,'XTickLabels',ticklabels)
set(gca,'fontname','Avant Garde')
set(gca,'fontsize',24)
set(gca,'fontweight','bold')


function MDC = getMDC(PairedData)

data = PairedData(:,1)/9.81;

SEM = std(data)./sqrt(length(data));

MDC = 1.96*(SEM)*sqrt(2);

end

function [minData,maxData,meanData,Q1,Q3] = getStats(Data)

D = rmoutliers(Data);
minData = min(D);
maxData = max(D);
meanData = median(D);
Q1 = median(D(find(D<median(D))));
Q3 = median(D(find(D>median(D))));


end



function make_boxchart(frame, UB, LB, Q1, Q3, MiddleNum,color,boxWidth,linewidth)
midpoint = mean(frame);
box(Q1,Q3,frame(1),frame(2),color,linewidth); %make the box
verticalLine(LB,Q1,midpoint,color,linewidth) %make the bottom line
verticalLine(Q3,UB,midpoint,color,linewidth) %make the bottom line
horizLine(frame(1),frame(2),MiddleNum,color,linewidth) %Make ;line for the mean
horizLine(frame(1),frame(2),LB,color,linewidth)
horizLine(frame(1),frame(2),UB,color,linewidth)
end

function box(lower,upper,left,right,color,linewidth)
verticalLine(lower,upper,left,color,linewidth) %left side
verticalLine(lower,upper,right,color,linewidth) %right side
horizLine(left,right,lower,color,linewidth) %bottom side
horizLine(left,right,upper,color,linewidth) %top side
end

function verticalLine(bottom,top,location,color,linewidth)
plot([location location],[bottom top],'Color',color,'LineWidth',linewidth)
end

function horizLine(left,right,height,color,linewidth)
plot([left right],[height height],'Color',color,'LineWidth',linewidth)
end


