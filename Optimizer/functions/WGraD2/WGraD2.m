function [networkInfo, para] = WGraD2(para)
input       = para.sampledata(:, 1 : end - 1);
output      = para.sampledata(:, end);
count       = 0;
%%
%calcluate distance matrix
[nodelist, nodelist2] = WGraD2Climbing(input, output);
NewNetWork = CreateHeap(nodelist2, length(output));
% NewNetWork = spanningtree(nodelist);
%%
networkInfo = NewNetWork;
para.sampledata = [input output];
para.FEs = count;
[networkInfo, NWScore] = NetworkEvaluation(networkInfo, para);
para.NWScore = NWScore;
end