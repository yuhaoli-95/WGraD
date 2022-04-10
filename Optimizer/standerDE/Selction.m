function [offspring, fitness_off, bestX, fitnessbestX, parent, parentfitness] = Selction(X, C, fitnessX, fitnessC, fitnessbestX, bestX)
[NP, Dim]                = size(X);
offspring                = zeros(NP, Dim);
parent                   = zeros(NP, Dim);
fitness_off              = zeros(NP, 1);
parentfitness            = zeros(NP, 1);
for i = 1 : NP
    %maximize
    %C(i) is better
    if fitnessC(i) >= fitnessX(i)
        offspring(i, :)  = C(i, :);
        fitness_off(i)   = fitnessC(i);
        parent(i, :)     = X(i, :);
        parentfitness(i) = fitnessX(i);
        if fitnessC(i) > fitnessbestX%max solution is best
            bestX        = C(i, :);
            fitnessbestX = fitnessC(i);
        end
    else%fitnessC(i) <= fitnessX(i)
        offspring(i, :)  = X(i, :);
        fitness_off(i)   = fitnessX(i);
        parent(i, :)     = C(i, :);
        parentfitness(i)  = fitnessC(i);
    end
end
end