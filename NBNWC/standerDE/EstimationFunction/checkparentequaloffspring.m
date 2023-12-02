function [index, P, O, PF, OF] = checkparentequaloffspring...
    (parent, offspring, parentfitness, fitness_off)
%%
%check offspring and parents: order
[NP, Dim] = size(parent);
P = zeros(NP, Dim);
O = P;
PF = zeros(1, NP);
OF = zeros(1, NP);
for indIth = 1 : NP
    if fitness_off(indIth) < parentfitness(indIth)
        P(indIth, :) = parent(indIth, :);
        PF(indIth) = parentfitness(indIth);
        O(indIth, :) = offspring(indIth, :);
        OF(indIth) = fitness_off(indIth); 
    else
        P(indIth, :) = offspring(indIth, :);
        PF(indIth) = fitness_off(indIth);
        O(indIth, :) = parent(indIth, :);
        OF(indIth) = parentfitness(indIth);
    end
end
%%
%check offspring and parents: equal
index = zeros(length(offspring(:, 1)), 1);
D1 = parent - offspring;
D2 = D1 .^ 2;
index(sqrt(sum(D2, 2)) ~= 0) = 1;%if b = [0,0,0,...,0]
end