clear all;close all;clc;
foldername = [{'..\..\data\Test2AP_DE_1_0.5_0.5_500DLHS_endcondition3\'}];%{'..\data\nea2-tables\nea2+'}
FuncArray = [1 : 9];
ECFunc = zeros(20, 3);
for ProblemIth = FuncArray
    %%
    clc
    disp(['name of method: ', char(foldername(1))]);
    %%
    ECtemp = zeros(50, 3);
    fprintf('Function ID: %03d\n', ProblemIth);
    for Runtime = 1 : 50
        %%
        filename = [char(foldername(1)), 'FuncID', num2str(ProblemIth)...
            '\run', num2str(Runtime, '%03d'), 'MMOresult.mat'];
        data = load(filename, '');
        ECArray = data.ECArray;
        TECnum = zeros(1, 3);
        for ECIth = 1 : 3
            TECnum(1, ECIth) = length(find(ECArray == ECIth)) / length(ECArray);
        end
        ECtemp(Runtime, :) = TECnum;
    end
    ECFunc(ProblemIth, :) = mean(ECtemp);
end
bar(1:20, ECFunc, 'stacked');
legend('EC1', 'EC2', 'EC3');
title(['Comparison of End Condition']);
axis([0 21 0 1]);
saveas(gcf, [char(foldername(1)), 'Comparison_of_End_Condition.fig']);
saveas(gcf, [char(foldername(1)), 'Comparison_of_End_Condition.bmp']);