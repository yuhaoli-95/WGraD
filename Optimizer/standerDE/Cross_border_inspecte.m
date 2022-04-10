function [X, fitnessX] = Cross_border_inspecte(X, param)
Xmin                     = param.lb;
Xmax                     = param.ub;
[NP, Dim]                = size(X);
fitnessX                 = zeros(NP, 1);
for i = 1 : NP
    for j = 1 : Dim
        if(X(i, j) < Xmin(j))
            X(i, j) = Xmax(j) - abs(mod((X(i, j) - Xmin(j)), (Xmax(j) - Xmin(j))));
        elseif(X(i, j) > Xmax(j))
            X(i, j) = Xmin(j) + abs(mod((Xmin(j) - X(i,j)), (Xmax(j) - Xmin(j))));
        end
    end
    fitnessX(i) = fitness(X(i, :), param);
end
end