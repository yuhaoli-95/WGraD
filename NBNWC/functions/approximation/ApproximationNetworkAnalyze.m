function [networkInfo, para] = ApproximationNetworkAnalyze(para, ifGraph)
input       = para.AnalysisData(:, 1 : end - 1);
output      = para.AnalysisData(:, end);
alpha       = 0.0 : 0.1 : 1;
count       = 0;
% plot_Landscape(para, 0, 1, 1);
% open('.\FuncID11_contour.fig');
% hold on
%%
W = 11;
%%
%calcluate distance matrix
[nodelist, ~, H, P] = ApproximationConnectRelationship(input, output, alpha(W), ifGraph);
NewNetWork = ConnectNetWork(nodelist);
%%
Model_Num_info1(W) = length(NewNetWork);%{NewCluster};
%     figureset(ifGraph, para, alpha(W), W, length(nodelist(:, 1)), count + SampleNum * times, length(NewNetWork), '.bmp', H, P, 0);
%%
if ifGraph & (para.D == 1 | para.D == 2)
    delete(H);
    delete(P);
end
old_num = length(NewNetWork);
old_nodelist = nodelist;
%%
%     display(['FuncID = ', num2str(FuncID),' || Weight = ', num2str(alpha(W)), ' || # of NW = ', num2str(Model_Num_info2(W)), ' || # of SP = ', num2str(length(output)), ' || # of FEs = ', num2str(count + SampleNum)]);
% plotNetWork(NewNetWork, para, 0, FuncID, W, alpha, input, output, SampleNum);
% close all;
%% calculate "score" of each sub-graph and sort them by the score
networkInfo = NewNetWork;
para.sampledata = [input output];
para.FEs = count;
[networkInfo, NWScore] = NetworkEvaluation(networkInfo, para);
para.NWScore = NWScore;
end