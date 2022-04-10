function WArray = AngleWeight(Parent, offspring, estimation, checkindex)
index = find(checkindex == 1);
%each line is an individual, each colomn is a variable
offspring = offspring(index, :);
Parent = Parent(index, :);
%%
b = offspring - Parent;
estimationvector = repmat(estimation, length(offspring(:, 1)), 1) - Parent;
lengthb = sqrt(sum(b .^ 2, 2));
lengthEV = sqrt(sum(estimationvector .^ 2, 2));
costheta = 1 + (sum(b .* estimationvector, 2)) ./ (lengthb .* lengthEV);
WArray = costheta ./ sum(costheta);
WArray = 1 - WArray;
end