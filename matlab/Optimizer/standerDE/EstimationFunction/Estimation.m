function elite = Estimation(parents, offspring, popnum, genenum, checkindex, WArray)
if length(parents(1, :)) ~= genenum
    error();
end
if length(parents(:, 1)) ~= popnum
    error();
end
popnum = sum(checkindex);
index = find(checkindex == 1);
parents = parents(index, :);
offspring = offspring(index, :);
%%
%in DE problem, parents and offspring are [indi, gene]. 
%but in paper, each vector is colomn vector.
%so parents = parents(T), offspring = offspring(T).
offspring = offspring';
parents = parents';
b = offspring - parents;%obtain moving vector bi
bo = zeros(genenum, popnum);%boi = bi / ||bi||
for boith = 1 : popnum
    tempb = b(:, boith);%bo is a colomn vector
    bo(:, boith) = tempb / sqrt(sum(tempb .^ 2));
end
H = cat(popnum, zeros(genenum));%boi = bi / ||bi||
%Hi = I - boi * boi(T). Hi is a (genenum * genenum) matrix.
unit_matrix = eye(genenum);
for Hith = 1 : popnum
    H(:, :, Hith) = WArray(Hith) * (unit_matrix - (bo(:, Hith) * bo(:, Hith)'));
end
%part1
X1 = sum(H, 3);
%part2
X2i = zeros(genenum, popnum);
for X2ith = 1 : popnum
    X2i(:, X2ith) = WArray(Hith) * H(:, :, X2ith) * parents(:, X2ith);
end
X2 = sum(X2i, 2);
%calculate elite
elite = (inv(X1) * X2)';
% elite = (X1 \ X2)';
end