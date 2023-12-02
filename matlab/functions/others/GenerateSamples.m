function ClusterPara = GenerateSamples(ClusterPara)
SampleNum = ClusterPara.SampleNum;
Dim       = ClusterPara.Dim;
lb        = ClusterPara.lb;
ub        = ClusterPara.ub;
Samples   = zeros(SampleNum, Dim);
%%
% q = 20;
% [popold_orig] = Cell_Init_x_mex (lb, ub, Dim,q);
% Samples = unique(popold_orig, 'rows');
% SampleNum = length(Samples(:, 1));
% ClusterPara.SampleNum = SampleNum;
for D = 1 : Dim
    t = linspace(lb(D), ub(D), SampleNum);
    Samples(:, D) = t(randperm(length(t)));
end

SampleFitness = zeros(SampleNum,1);
for ith = 1 : SampleNum
    SampleFitness(ith) = fitness(Samples(ith, :), ClusterPara);
end
ClusterPara.sampledata = [Samples SampleFitness];
end