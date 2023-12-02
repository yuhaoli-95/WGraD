function [MMO_sol, fes, fesArray, TArray] = CheckSolution(MMO_sol, NewSol, fes, FuncID, fesArray, TArray)
% Check if the optimal individual found by the DE algorithm is a new optimal solution.
%%
if isempty(MMO_sol)
    MMO_sol = NewSol;
    fesArray(end + 1) = fes;
    TArray(end + 1) = toc;
    return;
end
%compare the new solution and its nearest solution
[ifhill, fes, index] = HillValleyTest(MMO_sol, NewSol, fes, FuncID);
%the new solution and the nearest solution are in the different hills
if ifhill
    if NewSol(1, end) > MMO_sol(index, end)
        MMO_sol(index, :) = NewSol;%new solution is better than the nearest solution
        fesArray(index) = fes;
        TArray(index) = toc;
    end
else
    MMO_sol = [MMO_sol; NewSol];%find a new solution
    fesArray(end + 1) = fes;
    TArray(end + 1) = toc;
end
end