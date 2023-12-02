function [ifhill, fes, index] = HillValleyTest(MMO_sol, NewSol, fes, param)
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
num = (1 : 5)';
Test = repmat(CheckSX, max(num), 1) + ( ( ( norm(NewSX - CheckSX) /max(num) ) .* num ) ) .* unitv;%obtain test point
%% Hill-Valley Test
SamFitT = zeros(max(num) - 1, 1);
for Samplith = 1 : max(num) - 1
    fes = fes + 1;
    SamFitT(Samplith, 1) = fitness(Test(Samplith, :), param);
    %     SamFitT(Samplith, 1) = DE_programming_testFun(Test(Samplith, :), FuncID);
    if SamFitT(Samplith, 1) < min([CheckSF NewSF])
        %offspring and Best are in the different hill
        ifhill = 0;
        break;
    end
end
end