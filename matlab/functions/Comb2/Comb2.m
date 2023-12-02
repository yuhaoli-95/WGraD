function [networkInfo, para] = Comb2(para)
input       = para.sampledata(:, 1 : end - 1);
output      = para.sampledata(:, end);
count       = 0;
%%
%calcluate distance matrix
[nodelist1, nodelist2, ~, ~, EdgeDis] = WGraD2Climbing(input, output);
%%
%rule1
theta = 2;
avedis = mean(EdgeDis);
nodelist1(EdgeDis > theta * avedis, :) = [];
nodelist2(EdgeDis > theta * avedis, 2) = -1;
% %rule 2
% [samnum, Dim] = size(input);
% count1 = 0;
% count2 = 0;
% b = log10(samnum) * (-0.000469 * Dim ^ 2 + 0.0263 * Dim + 3.66 / Dim - 0.457) + (0.000751 * Dim ^ 2 - 0.0421 * Dim - 2.26 / Dim + 1.83);
% for samith = 1 : samnum
%     [~, incomenode] = find(nodelist1(:, 2)' == samith);
%     if length(incomenode) >= 3
%         count1 = count1 + 1;
%         tempedges = nodelist1(incomenode, :);
%         meslength = median(tempedges(:, 2));
%         if nodelist1(nodelist1(:, 1) == samith, 2) / meslength > b
%             count2 = count2 + 1;
%             nodelist1(nodelist1(:, 1) == samith, :) = [];
%             nodelist2(nodelist2(:, 1) == samith, 2) = -1;
%         end
%     end
% end
%%
NewNetWork = CreateHeap(nodelist2, length(output));
% NewNetWork1 = spanningtree(nodelist1);
%%
networkInfo = NewNetWork;
para.sampledata = [input output];
para.FEs = count;
[networkInfo, NWScore] = NetworkEvaluation(networkInfo, para);
para.NWScore = NWScore;
end