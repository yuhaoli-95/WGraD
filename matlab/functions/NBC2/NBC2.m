function [networkInfo, para] = NBC2(para)
input       = para.sampledata(:, 1 : end - 1);
output      = para.sampledata(:, end);
%%
[nodelist, nodelist2] = NBC2Climbing(input, output);
nodelist = nodelist(:, [1 3]);
nodelist2 = nodelist2(:, [1 3]);
NewNetWork = CreateHeap(nodelist, length(output));
% NewNetWork2 = ConnectNetWork(nodelist2);
%%
networkInfo = NewNetWork;
para.sampledata = [input output];
para.FEs = 0;
[networkInfo, NWScore] = NetworkEvaluation(networkInfo, para);
para.NWScore = NWScore;
end