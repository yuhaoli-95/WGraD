% obtain statistical test result of the WILCONXON SIGNED-RANK TEST and the HOLM’S MULTIPLE COMPARISON
clear all; close all; clc;
proname = [{'WGraD1'}, {'WGraD2'}, {'NBC2'}]; % {'Switch1'}, {'Switch2'}, {'NBC2'}, {'WGraD1'}, {'WGraD2'}, {'Comb1'}, {'Comb2'}
count = 1;
P = [];
for D = [ 2  4  6 8 10 20]%
    for FuncID = [1 6 7 2 3 4 5 8]
        CaseName = ['F', num2str(FuncID), 'D', num2str(D)];
        % load # of global optima of each method: [alg_1, alg_2, ..., alg_n]
        for mIth = 1 : length(proname)
            Temp = load(['.\', char(proname(mIth)), '.mat'], CaseName);
            eval(['data(:, mIth) = Temp.', CaseName, ';']);
        end
        ave(count, :) = mean(data);
        mindata(count, :) = min(data);
        maxdata(count, :) = max(data);
        [a(count, :), index] = sort(ave(count, :));
        temp(count, 1) = {['Func', num2str(FuncID)]};%, '_', num2str(D), 'D'
        temp(count, 2) = {[num2str(D), 'D']};
        %%
        % sort the name of algorithms by # of found optima
        temp(count, [3 : 2 : (3 + (length(index) - 1) * 2)]) = proname(index);
        %%
        % calculate p-value of the i-th algorithm and the i+1-th algorithm
        AGroup = [];
        BGroup = [];
        for i = 1 : length(proname)
            for j = i + 1 : length(proname)
                if j == i + 1
                    pro1 = data(:, index(i));
                    pro2 = data(:, index(j));
                    pvalue = signrank(pro1, pro2);
                    AGroup = [AGroup pvalue];
                else
                    pro1 = data(:, index(i));
                    pro2 = data(:, index(j));
                    pvalue = signrank(pro1, pro2);
                    BGroup = [BGroup pvalue];                    
                end
            end
        end
        pvalue = [AGroup BGroup];
        %%
        % apply the HOLM’S MULTIPLE COMPARISON to modify the p-value
        Sign = Holm(pvalue);
        temp(count, [4 : 2 : (4 + (length(index) - 2) * 2)]) = Sign(1 : length(proname) - 1);
        %%
        count = count + 1;
    end
end
temp
for i = 1 : count - 1
    for j = 1 : length(proname)
        temp(i, j * 2 + 1) = {[char(temp(i, j * 2 + 1)), ' (', num2str(a(i, j), '%.3f'), ')']};
    end
end
% save statistics test result
xlswrite(['.\Result_StasticsTest.xlsx'], temp);
xlswrite(['.\Result_StasticsTest.xlsx'], a, 'a');
xlswrite(['.\Result_StasticsTest.xlsx'], ave, 'ave');
xlswrite(['.\Result_StasticsTest.xlsx'], mindata, 'mindata');
xlswrite(['.\Result_StasticsTest.xlsx'], maxdata, 'maxdata');

%%
function Sign = Holm(pvalue)
Sign = cell(1, length(pvalue));
for i = 1 : length(pvalue)
    Sign(i) = {'='};
end
for i = 1 : length(pvalue)
    [p, index] = min(pvalue);
    CorrectionVal = (length(pvalue) + 1 - i);
    if pvalue(index) * CorrectionVal <= 0.01
        Sign(index) = {'<<'};
    elseif pvalue(index) * CorrectionVal <= 0.05
        Sign(index) = {'<'};
    else
        break;
    end
    pvalue(index) = 2;
end
end