function [ifhill, fes, index] = HillValleyTest(MMO_sol, NewSol, fes, FuncID)
% Check whether there is a "valley" between the current best solution and 
% the nearest solution of known optimal solutions, 
% that is, whether there are points that are worse than both of these
% points. 

% Input: 
%   MMO_sol: all best individuals so far
%   NewSol: the current best individual in the current samples
%   fes: the current number of fitness function evaluations
%   FuncID: test function id
% Output:
%   ifhill: 1 means there is a "valley" ==> alg find a new hill
%   fes: the updated number of fitness function evaluations
%   index: the index of the solution closest to NewSol
%%
ifhill = 1;
%% find the nearest solution
MMO_solX = MMO_sol(:, 1 : end - 1);
NewSolX = NewSol(1, 1 : end - 1);
Dis = pdist2(NewSolX, MMO_solX);
[~, index] = min(Dis);
CheckSol = MMO_sol(index, :);
%% 
CheckSX = CheckSol(:, 1 : end - 1);
CheckSF = CheckSol(:, end);
NewSX = NewSol(:, 1 : end - 1);
NewSF = NewSol(:, end);
%% get test solutions
unitv = (NewSX - CheckSX) / (norm(NewSX - CheckSX));%obtain unit vector: the new solution -> the nearest solution
if isnan(unitv)
    return;%the new solution == the nearest solution
end
% 
num = (1 : 5)';
Test = repmat(CheckSX, max(num), 1) + ( ( ( norm(NewSX - CheckSX) /max(num) ) .* num ) ) .* unitv;%obtain test point
%% Hill-Valley Test
SamFitT = zeros(max(num) - 1, 1);
for Samplith = 1 : max(num) - 1
    fes = fes + 1;
    SamFitT(Samplith, 1) = DE_programming_testFun(Test(Samplith, :), FuncID);
    if SamFitT(Samplith, 1) < min([CheckSF NewSF])
        %offspring and Best are in the different hill
        ifhill = 0;
        break;
    end
end
end