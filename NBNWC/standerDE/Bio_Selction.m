function [offspring, fitness_off, fitnessU] = Bio_Selction(X,U,fitnessX,fitnessbestX,bestX,param)
[NP,~]       = size(X);
offspring    = zeros(size(X));
fitness_off  = zeros(NP,1);
FuncID       = param.fitness_index;
fitnessU     = zeros(NP,1);
for i = 1 : NP
    fitnessU(i) = DE_programming_testFun(U(i,:),FuncID);
end
%
Pop = [X; U];
PopFit = [fitnessX; fitnessU];
Xdistance = pdist2(Pop, Pop);
DisFes = mean(Xdistance, 2);
FitScore = mapminmax(PopFit);
DisScore = mapminmax(DisFes);
Score = FitScore + DisScore;
[~, index] = sort(Score, 'descend');
index_of_fronts = non_domination_sort_mod([PopFit DisFes], 2, 0);
offspring = Pop(index_of_fronts(1 : NP), :);
fitness_off = PopFit(index_of_fronts(1 : NP), :);
end