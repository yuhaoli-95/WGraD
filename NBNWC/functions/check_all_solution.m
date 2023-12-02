function [solution, fesArray, TArray] = check_all_solution(MMO_sol, accuracy, fesArray, TArray)
solution = MMO_sol;
Fit = MMO_sol(:, end);
if length(Fit) > 1
    [MaxFit, ~] = max(Fit);
    [~, index] = find(MaxFit - Fit' < accuracy);%delete all solutions that are lower than MaxFit - accuracy
    solution = MMO_sol(index, :);
    fesArray = fesArray(index);
    TArray = TArray(index);
end
end