%Import trial data from XSens output

function [data,sheets] = Import_XSens(filename)

[sheets] = sheetnames(filename);

for i = 1:numel(sheets)
        data{i} = readtable(filename,'Sheet',sheets(i),'VariableNamingRule','preserve');
end

end