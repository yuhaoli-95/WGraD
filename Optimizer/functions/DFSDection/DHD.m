function [networkInfo, para] = DHD(para)
input       = para.sampledata(:, 1 : end - 1);
output      = para.sampledata(:, end);
%%
% plot_Landscape(para, 0, 0, 1);
% [DisGraph, FitGraph] = DisFisGraph(input, output);para.FuncID
Cluster = DownHillDection(input, output, 1);

networkInfo = Cluster;
para.sampledata = [input output];
para.FEs = 0;
[networkInfo, NWScore] = NetworkEvaluation(networkInfo, para);
para.NWScore = NWScore;
end