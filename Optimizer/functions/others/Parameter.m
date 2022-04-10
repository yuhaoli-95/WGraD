function [ClusterPara, OptiPara] = Parameter(para, FuncID, Dim)
%%
ClusterPara = para.Problem;
ClusterPara.FuncID = FuncID;
ClusterPara.Dim = Dim;
%%
OptiPara = para.OptimizerPara;
OptiPara.name = para.Optimizer;
OptiPara.FuncID = FuncID;
OptiPara.Dim = Dim;
OptiPara.MaxFes = para.Problem.MaxFes;
OptiPara.lb = para.Problem.lb;
OptiPara.ub = para.Problem.ub;
OptiPara.Benchmark = para.Problem.Benchmark;
%%
if strcmp(para.Problem.Benchmark, 'cec15_nich_func')
    
end
if length(para.Problem.lb) ~= Dim
    error('wrong: lb and ub');
end
end