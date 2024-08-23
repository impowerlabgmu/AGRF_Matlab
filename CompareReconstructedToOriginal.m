%Must Run P_Spec_R2.m first, and this works for one participant, not if you
%loop through all.
clear
clc

load('ReconstructedCompareData.mat')


t = tiledlayout(1,2);
nexttile

[r2,c2] = size(Cell_plot);

hold on

for i = 1:r2

    plot(Cell_plot{i,2}/9.81, 'b')
    %cellfun(@plot, Cell_plot{r2,2}, 'b')

end
ylim([-0.3 0.3])
title('Original AGRF')
ylabel('AGRF (BW)')
xlabel('Samples')
hold off
set(gca,'fontname','Avant Garde')
set(gca,'fontsize',24)
set(gca,'fontweight','bold')
pbaspect([1 1 1])




nexttile
hold on

for i = 1:r2
    plot(Cell_plot{i,1}, 'r')
    %cellfun(@plot, Cell_plot{r2,1}, 'r')
end
ylim([-0.3 0.3])
title('Reconstructed AGRF')
ylabel('AGRF (BW)')
xlabel('Samples')
set(gca,'fontname','Avant Garde')
set(gca,'fontsize',24)
set(gca,'fontweight','bold')
pbaspect([1 1 1])
hold off





