function [fes, BestIndi, all] = DE(DEpara, pop, fes)
%%
%step1:initialization first gerenation
[X, XFit, fes] = Initiallization(pop, DEpara, fes);
NP          = DEpara.NP;
Xdistance   = pdist(X);
GMax        = DEpara.stopgeneration;
tolerance   = DEpara.tolerance;
array = [];
OldBest = 0;
all = [];
%%
while max(Xdistance) > DEpara.maxdistance%10^-8
    [BestXFit, indexbestX] = max(XFit);%fitnessbestX is the best fitness
    BestX = X(indexbestX,:);%bestX is best solutation
    %%
    %step2:mutation
    [M] = Mutation(X, BestX, DEpara);
    %step2.2:crossover
    [C] = Crossover(X, M, DEpara);
    %step3:check border of offspring U
    [C, CFit] = Cross_border_inspecte(C, DEpara);
    all = [all; C, CFit];
    %%
    %step4:selection
    [offspring, fitness_off, ~, ~, ~, ~] = Selction(X, C, XFit, CFit, BestXFit, BestX);
    %%
    fes = fes + NP;
%     if fes > DEpara.MaxFes
%         break;
%     end
    %%
    if length(array) > GMax
        if array(end - GMax + 1 : end) < tolerance%end - GMax + 1 : end
            break;
        end
    end
    %%
    X = offspring;
    XFit = fitness_off;
    Xdistance = pdist(X);
    best = max(XFit);
    array(end + 1) = best - OldBest;
    OldBest = best;
end
[bestfit, index] = max(XFit);
BestIndi = [X(index, :) bestfit];%[X, fitnessX];%
end



