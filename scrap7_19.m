% Individual_Trials;

Target = cell2mat(RSquared(:,10))';

Trials = 1:length(Target);
tabstart = [Trials; RSquared_Opt; Target]';


Names{1} = 'Trial';

for p = 1:r
    Names{p+1} = char(join(names(combinations(p,:)),' '));
end

Names{p+2} = 'Full Set';

T = array2table(tabstart);
T.Properties.VariableNames(1:p+2) = Names;


scatter(T,'Trial',Names(2:end),'filled');
legend
ylim([0 1])
ylabel('RSquared')

% scatter(ScatterData(:,1),ScatterData(:,2))
% ylim([0.85 1])
% xlim([1 2])
% 
% xlabel('Speed (m/s)')
% ylabel('R-Squared')
% 
% title('Full DataSet')




