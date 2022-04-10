function [ClusterPara, OptiPara] = SetParameter(optimizer, SampleNum, Benchmark, MaxFes, lb, ub, Dim)
if length(lb) ~= Dim | length(ub) ~= Dim
    error('wrong: lb and ub');
end
%%
OptiPara.lb = lb;
OptiPara.ub = ub;
OptiPara.Dim = Dim;
OptiPara.name = optimizer;
OptiPara.MaxFes = MaxFes;
OptiPara.Benchmark = Benchmark;
datatable = importdata([optimizer, '.txt']);  %load DE parameter
for txti = 1 : length(datatable)
    eval(char(datatable(txti)));
end
%%
ClusterPara.lb = lb;
ClusterPara.ub = ub;
ClusterPara.Dim = Dim;
ClusterPara.MaxFes = MaxFes;
ClusterPara.Benchmark = Benchmark;
ClusterPara.SampleNum = SampleNum;
end