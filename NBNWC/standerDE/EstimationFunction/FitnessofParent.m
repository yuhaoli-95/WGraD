function WArray = FitnessofParent(parentFV, checkindex)
index = find(checkindex == 1);
parentFV = parentFV(index);
bestparent = min(parentFV);
worstparent = max(parentFV);
WArray = (worstparent - parentFV) / (worstparent - bestparent);
WArray = WArray ./ sum(WArray);
WArray = 1 - WArray;
end