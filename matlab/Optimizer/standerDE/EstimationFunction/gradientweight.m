function [repar, reoff, reparF, reoffF, WArray, checkindex] = gradientweight(Parent, offspring, ParentFV, offspringFV, checkindex)
%%
index1 = find(checkindex == 1);
index0 = find(checkindex == 0);
%each line is an individual, each colomn is a variable
Toffspring = offspring(index1, :);
TParent = Parent(index1, :);
TParentFV = ParentFV(index1);
ToffspringFV = offspringFV(index1);
indi0 = offspring(index0, :);
indiF0 = offspringFV(index0);
[TempSampleNum, ~] = size(TParentFV);
%%
disTemp = zeros(TempSampleNum);
DeltaFVTemp = zeros(TempSampleNum);
par = zeros(TempSampleNum, 1);
off = zeros(TempSampleNum, 1);
gra = zeros(TempSampleNum, 1);
%%
for SIth = 1 : TempSampleNum
    pointI = TParent(SIth, :);
    fitnessI = TParentFV(SIth);
    disTemp(SIth, :) = sqrt(sum((repmat(pointI, TempSampleNum, 1) - Toffspring) .^ 2, 2))';
    DeltaFVTemp(SIth, :) = (ToffspringFV - repmat(fitnessI, TempSampleNum, 1))';
end
gradientmat = DeltaFVTemp ./ disTemp;
worstgra = max(max(gradientmat));
for SIth = 1 : TempSampleNum
    gra(SIth) = min(min(gradientmat));
    [row, column] = find(gradientmat == gra(SIth));
    par(SIth) = row(1);
    off(SIth) = column(1);
    gradientmat(par(SIth), :) = worstgra + 1;
    gradientmat(:, off(SIth)) = worstgra + 1;
end
repar = [TParent(par, :); indi0]; reparF = [TParentFV(par); indiF0];
reoff = [Toffspring(off, :); indi0]; reoffF = [ToffspringFV(off); indiF0];
gra = 1 - gra ./ sum(gra);
WArray = [gra; zeros(length(index0), 1)];
checkindex = [ones(length(index1), 1); zeros(length(index0), 1);];
end