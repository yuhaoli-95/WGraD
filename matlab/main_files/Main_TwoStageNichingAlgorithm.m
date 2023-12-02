function Main_TwoStageNichingAlgorithm(Problem, lb, ub, Dim, MaxFes, method, NP, Optimizer, FolderName, RepIth)
% the main process of niche algorithm
% input: 
% Problem, lb, ub, Dim, MaxFes: parameters of one benchmark function; 
% Optimizer: DE/CMA-ES; 
% FolderName: result
% RepIth: random seed; 
% output: 
tic
warning off
% obtain the optimization method parameters and cluster method parameters
[ClusterPara, OptiPara] = SetParameter(Optimizer, NP, Problem, MaxFes, lb, ub, Dim);
rng(RepIth, 'twister');
% set data file path
DataFileFolderName = [FolderName, '/']; CheckFolder(DataFileFolderName);
% check benchmark function version
if contains(Problem, 'cec15_nich_func')
    FuncID = str2double(Problem(16 : end));
    ClusterPara.FuncID = FuncID;
    OptiPara.FuncID = str2double(Problem(16 : end));
    ClusterPara.Benchmark = 'cec15_nich_func';
    OptiPara.Benchmark = 'cec15_nich_func';
elseif contains(Problem, 'cec13_nich_func')
    FuncID = str2double(Problem(16 : end));
    ClusterPara.FuncID = FuncID;
    OptiPara.FuncID = str2double(Problem(16 : end));
    ClusterPara.Benchmark = 'cec13_nich_func';
    OptiPara.Benchmark = 'cec13_nich_func';
end
%%
fes = 0;
BestIndi1 = [];
MaxFes = ClusterPara.MaxFes;
tic
% while fes < MaxFes
[fes, BestIndi, CN] = TwoStageNichingAlgorithm(fes, BestIndi1, method, ClusterPara, OptiPara);
% end
t=toc;
%%
fprintf('f_%02d, D_%02d, rth: %02d, #: %f\n', FuncID, Dim, RepIth, t);%, niche.c1, niche.c2, niche.bb);
save([DataFileFolderName, 'F', num2str(FuncID, '%02d'), 'D', num2str(Dim, '%02d'), 'Run', num2str(RepIth, '%02d'), '.mat']);
end