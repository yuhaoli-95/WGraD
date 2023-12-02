function [X, XFit, fes] = Initiallization(pop, DEpara, fes)
X               = pop(:, 1 : end - 1);
[N, ~]          = size(X);
Xmin            = DEpara.lb;
Xmax            = DEpara.ub;
if DEpara.NP <= N
    index       = randperm(N);
    pop         = pop(index(1 : DEpara.NP), :);
else
    pop_temp    = Xmin + (Xmax - Xmin) .* rand(DEpara.NP - N, DEpara.Dim);
    pop_temp_f	= [];
    for i = 1 : DEpara.NP - N
        pop_temp_f(i, 1) = fitness(pop_temp(i, :), DEpara);
    end
    fes         = fes + DEpara.NP - N;
    pop         = [pop; pop_temp pop_temp_f];
end
X               = pop(:, 1 : end - 1);
XFit            = pop(:, end);
end