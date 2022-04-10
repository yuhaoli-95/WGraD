function [networkInfo, para] = Comb1(para)
input       = para.sampledata(:, 1 : end - 1);
output      = para.sampledata(:, end);
alpha       = 0.0 : 0.1 : 1;
old_num     = 1;
count       = 0;
%%
for W = 1 : length(alpha) - 1
    %%
    %calcluate distance matrix
    [nodelist, ~] = WGraD1Climbing(input, output, alpha(W));
    NewNetWork = spanningtree(nodelist);
    %%
    if old_num ~= length(NewNetWork) & alpha(W) ~= 1
        %%
        %find point
        InsertPointList = [];
        InsertPointListFV = [];
        merge = [];
        for newNWi = 1 : length(NewNetWork)
            tempnew = cell2mat(NewNetWork(newNWi));
            [TIP, TIPFV, Tcount, merge_t] = InsertPoint(para, tempnew, nodelist, old_nodelist, input, output);
            InsertPointList = [InsertPointList; TIP];
            InsertPointListFV = [InsertPointListFV; TIPFV];
            count = count + Tcount;
            merge = [merge; merge_t];
        end
        %%
        if ~isempty(InsertPointList)
            %%
            for mergeI = 1 : length(merge(:, 1))
                t1 = merge(mergeI, 1);
                t2 = merge(mergeI, 2);
                nodelist(t1, 2) = t2;
            end
            NewNetWork = spanningtree(nodelist);
        end
    end
    %%
    old_num = length(NewNetWork);
    old_nodelist = nodelist;
end
%%
P1 = input(nodelist(:, 1), :);
P2 = input(nodelist(:, 2), :);
EdgeDis = sqrt( sum((P1 - P2) .^ 2, 2) );
nodelist1 = nodelist;
nodelist2 = nodelist;
%rule1
theta = 2;
avedis = mean(EdgeDis);
countRule1 = length(find(EdgeDis > theta * avedis));
nodelist1(EdgeDis > theta * avedis, 2) = find(EdgeDis > theta * avedis);
nodelist2(EdgeDis > theta * avedis, 2) = -1;
%rule 2
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
%             nodelist1(nodelist1(:, 1) == samith, 2) = samith;
%             nodelist2(nodelist2(:, 1) == samith, 2) = -1;
%             count = count + 1;
%         end
%     end
% end
%%
% NewNetWork = CreateHeap(nodelist2, length(output));
NewNetWork = spanningtree(nodelist1);
%%
networkInfo = NewNetWork;
para.sampledata = [input output];
para.FEs = count;
[networkInfo, NWScore] = NetworkEvaluation(networkInfo, para);
para.NWScore = NWScore;
end