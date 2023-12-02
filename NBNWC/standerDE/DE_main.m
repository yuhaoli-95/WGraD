function [LastPop] = DE_main(remainFEs, pop, FuncID, Xmin, Xmax)
[param.NP, param.Dim]  = size(pop);
if param.NP > 50
    [~, index] = sort(pop(:, end));
    pop = pop(index(1 : 50), :);
end
param.fitness_index    = FuncID;
param.maxEva           = round(remainFEs / param.NP);
param.F                = 0.9;
param.CR               = 0.5;
param.mutationStrategy = 3;
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
LastPop=DE_Programming(param, pop);
end
