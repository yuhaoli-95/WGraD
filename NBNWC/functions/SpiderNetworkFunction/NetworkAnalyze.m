function [networkInfo, para] = NetworkAnalyze(para, ifGraph)
FuncID      = para.FuncID;
input       = para.AnalysisData(:, 1 : end - 1);
output      = para.AnalysisData(:, end);
SampleNum   = para.SamNum;
alpha       = 0.0 : 0.1 : 1;
old_num     = 1;
count       = 0;
% plot_Landscape(para, 0, 0, 1);
%%
for W = 1 : length(alpha) - 1
    %%
    %calcluate distance matrix
    [nodelist, ~, H, P] = ConnectRelationship(input, output, alpha(W), ifGraph);
    NewNetWork = ConnectNetWork(nodelist);
    %%
    Model_Num_info1(W) = length(NewNetWork);%{NewCluster};
    %     figureset(ifGraph, para, alpha(W), W, length(nodelist(:, 1)), count + SampleNum * times, length(NewNetWork), '.bmp', H, P, 0);
    %%
    if old_num ~= length(NewNetWork) & alpha(W) ~= 1
        %%
        %find point
        InsertPointlist = [];
        InsertPointlistFV = [];
        DeletePoint = [];
        for newNWi = 1 : length(NewNetWork)
            tempnew = cell2mat(NewNetWork(newNWi));
            [TIP, TIPFV, Tcount, DP, TH, TP] = Copy_of_InsertANDdeletePoint(para, tempnew, nodelist, old_nodelist, input, output, 0);
            InsertPointlist = [InsertPointlist; TIP];
            InsertPointlistFV = [InsertPointlistFV; TIPFV];
            DeletePoint = [DeletePoint; DP];
            H = [H TH]; P = [P TP];
            count = count + Tcount;
        end
        %figureset(ifGraph, para, alpha(W), W, length(nodelist(:, 1)), count + SampleNum * times, length(NewNetWork), 'supplyment1.bmp', H, P, 1);
        %%
        if ~isempty(InsertPointlist)
            %%
            %insert point
            input = [input; InsertPointlist];
            output = [output; InsertPointlistFV];
            %%
            [nodelist, ~, H, P] = ConnectRelationship(input, output, alpha(W), ifGraph);
            NewNetWork = ConnectNetWork(nodelist);
            Infor2(W) = {NewNetWork};
            %             figureset(ifGraph, para, alpha(W), W, length(nodelist(:, 1)), count + SampleNum * times, length(NewNetWork), 'supplyment2.bmp', H, P, 0);
        end
    end
    %%
    if ifGraph & (para.Dim == 1 | para.Dim == 2)
        delete(H);
        delete(P);
    end
    old_num = length(NewNetWork);
    old_nodelist = nodelist;
    %%
    Model_Num_info2(W) = length(NewNetWork);%{NewCluster};
    Model_info{W} = NewNetWork;
    %     display(['FuncID = ', num2str(FuncID),' || Weight = ', num2str(alpha(W)), ' || # of NW = ', num2str(Model_Num_info2(W)), ' || # of SP = ', num2str(length(output)), ' || # of FEs = ', num2str(count + SampleNum)]);
end
% plotNetWork(NewNetWork, para, 0, FuncID, W, alpha, input, output, SampleNum);
close all;
%%
networkInfo = NewNetWork;
para.sampledata = [input output];
para.FEs = count;
[networkInfo, NWScore] = NetworkEvaluation(networkInfo, para);
para.NWScore = NWScore;
end