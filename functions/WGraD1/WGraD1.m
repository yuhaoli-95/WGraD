function [networkInfo, para] = WGraD1(para)
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
% for i = 1 : length(NewNetWork)
%     Temp = cell2mat(NewNetWork(i));
%     if length(Temp) == 2
%         NewNetWork(i) = {[]};
%     end
% end
% NewNetWork(cellfun(@isempty,NewNetWork))=[];
networkInfo = NewNetWork;
para.sampledata = [input output];
para.FEs = count;
[networkInfo, NWScore] = NetworkEvaluation(networkInfo, para);
para.NWScore = NWScore;
end