function [MMO_sol, fes] = CheckSolution(MMO_sol, NewSol, fes, Problem)
if isempty(MMO_sol)
    MMO_sol = NewSol;
    return;
end
if isempty(NewSol)
    return;
end
%compare the new solution and its nearest solution
[ifhill, fes, index] = HillValleyTest(MMO_sol, NewSol, fes, Problem);
%the new solution and the nearest solution are in the different hills
if ifhill
    if NewSol(1, end) > MMO_sol(index, end)
        MMO_sol(index, :) = NewSol;%new solution is better than the nearest solution
    end
else
    MMO_sol = [MMO_sol; NewSol];%find a new solution
end
end