function WArray = FVofMovingVector(Parent, offspring, ParentFV, offspringFV, checkindex)
index = find(checkindex == 1);
Parent = Parent(index, :);
offspring = offspring(index, :);
ParentFV = ParentFV(index);
offspringFV = offspringFV(index);
%%
D1 = Parent - offspring;
D2 = D1 .^ 2;
distance = sqrt(sum(D2, 2));
delta = -1 * (offspringFV - ParentFV);
%%
gradient = delta' ./ distance;
WArray = gradient ./ sum(gradient); %* sum(checkindex);
WArray = 1 - WArray;
end