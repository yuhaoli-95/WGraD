function [param, pop, fes] = get_DEParame(remainFEs, pop, FuncID, Xmin, Xmax, fes)
[param.NP, param.Dim]  = size(pop(:, 1 : end - 1));
Dim = param.Dim;
if Dim == 1 | Dim == 2 | Dim == 3 | Dim == 5
    NP = 20;
elseif Dim == 10 | Dim == 20
    NP = 50;
end
if param.NP > NP
    index = randperm(param.NP);
    param.NP = NP;
    pop = pop(index(1 : param.NP), :);
elseif param.NP < NP
    popT = Xmin + (Xmax - Xmin) .* rand(NP - param.NP, param.Dim);
    popTFes = [];
    for i = 1 : NP - param.NP
        popTFes(i, 1) = DE_programming_testFun(popT(i, :),FuncID);
    end
    fes = fes + NP - param.NP;
    pop = [pop; popT popTFes];
    param.NP = NP;
end
param.fitness_index    = FuncID;
param.maxEva           = floor(remainFEs / param.NP);
param.F                = 0.5;
param.CR               = 0.5;
param.mutationStrategy = 2;
param.crossStrategy    = 1;
param.Xmin             = Xmin;
param.Xmax             = Xmax;
%mutationStrategy=1:DE/rand/1,
%mutationStrategy=2:DE/best/1,
%mutationStrategy=3:DE/rand-to-best/1,
%mutationStrategy=4:DE/best/2,
%mutationStrategy=5:DE/rand/2,
%crossStrategy=1:binomial crossover
%crossStrategy=2:Exponential crossover
end