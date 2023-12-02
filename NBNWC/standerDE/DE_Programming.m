function [fes, BestIndi, endcondition, gprMdl] = DE_Programming(param, FirstG, LoModal, fes)
%%
%Initialization const
maxIteration             = param.maxEva;
%%
%step1:initialization first gerenation
X                        = FirstG(:, 1 : end - 1);
fitnessX                 = FirstG(:, end);
[NP, ~]                  = size(X);
Xdistance                = pdist(X);
count = 0;
TMax = 1;
GMax = 50;
array = [];
BesstFesArray = [];
OldBest = 0;
tolerance = 10 ^ -5;
tolerancegp = 10 ^ -7;
X_train = [];
Y_train = [];
endcondition = 1;
AllPoint = [X fitnessX];
%%
while max(Xdistance) > 10^-10
    [fitnessbestX, indexbestX] = max(fitnessX);%fitnessbestX is the best fitness
    bestX = X(indexbestX,:);%bestX is best solutation
    %%
    %step2:mutation
    [M] = DE_programming_mutation(X, bestX, param);
    %step2.2:crossover
    [U] = DE_programming_crossover(X, M, param);
    %step3:check border of offspring U
    [U] = DE_programming_Cross_border_inspecte(U, param);
    [ED, X_train, Y_train] = GPEnd(TMax, tolerance, tolerancegp, array, X_train, X, Y_train, fitnessX, U);
    if ED == 3
        endcondition = 3;
        break;
    end
    %%
    %step4:selection
    [offspring, fitness_off, fitnessU] = DE_programming_selction(X, U, fitnessX, fitnessbestX, bestX, param, LoModal);
    %%
    if length(array) > GMax
        if array(end - GMax + 1 : end) < tolerance
            endcondition = 2;
            break;
        end
    end
    %%
    fitnessX = fitness_off;
    X = offspring;
    Xdistance = pdist(X);
    best = max(fitnessX);
    array(end + 1) = best - OldBest;
    BesstFesArray(end + 1) = best;
    OldBest = best;
    AllPoint = [AllPoint; U fitnessU];
    %%
    fes = fes + NP;
    if fes > get_maxfes(param.fitness_index)
        break;
    end
    %%
    %     H = plot3(X(:, 1), X(:, 2), fitnessX, '.k', 'Markersize', 15);
    %     pause(0.05);
    %     delete(H);
end
% gprMdl = fitrgp(AllPoint(:, 1 : end - 1), AllPoint(:, end), 'SigmaLowerBound', 0.2, 'Standardize', true, 'ComputationMethod', 'v', 'DistanceMethod','fast');
gprMdl = [];
[bestfit, index] = max(fitnessX);
BestIndi = [X(index, :) bestfit];%[X, fitnessX];%
% disp(['Iteration ' num2str(Generation) ': Best Cost = ' num2str(bestfit)]);
end



