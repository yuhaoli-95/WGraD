function [elite, elitefitness] = matrixoperator(proposal, parents, offspring, parentfitness, fitness_off, funcID)
[NP, Dim] = size(parents);
elite = [];
elitefitness = [];
[checkindex, parents, offspring, parentfitness, fitness_off] = ...
    checkparentequaloffspring(parents, offspring, parentfitness, fitness_off);
if sum(checkindex) ~= 0
    switch proposal
        case 2
            WArray = ones(sum(checkindex), 1) * (1 / NP);
        case 3
            WArray = FVofMovingVector(parents, offspring, parentfitness, fitness_off, checkindex);
        case 4
            WArray = ones(sum(checkindex), 1);
            estimation = Estimation(parents, offspring, NP, Dim, checkindex, WArray);
            WArray = AngleWeight(parents, offspring, estimation, checkindex);
        case 5
            WArray = FitnessofParent(parentfitness, checkindex);
        case 6
            [parents, offspring, ~, fitness_off, WArray, checkindex] = gradientweight(parents, offspring, parentfitness, fitness_off, checkindex);
    end
    index = find(checkindex == 1);
    indexnan = find(ismissing(WArray) == 1);
    checkindex(index(indexnan)) = 0;
    if sum(checkindex) ~= 0
        elite = Estimation(parents, offspring, NP, Dim, checkindex, WArray);
        elitefitness = feval('cec13_func', elite', funcID);
    end
end

if ~isempty(elitefitness)
    [worstfitness, switchindex] = max(fitness_off);
    if elitefitness < worstfitness
        fitness_off(switchindex) = elitefitness;
        offspring(switchindex, :) = elite;
        if elitefitness < fitnessbestX
            fitnessbestX = elitefitness;
        end
    end
end

end