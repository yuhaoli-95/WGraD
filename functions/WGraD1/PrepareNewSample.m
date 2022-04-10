function insertpoint = PrepareNewSample(PA, PB, PC, Dim)
disBA = sqrt(sum((PA - PB).^2));
VecBA = (PA - PB) / disBA;
disBC = sqrt(sum((PC - PB).^2));
%%
num = 5;
VecBA = (PA - PB) / num;
InsertVec = repmat(VecBA, num - 1, 1) .* repmat([1 : num - 1]', 1, Dim);
insertpoint = InsertVec + repmat(PB, num - 1, 1);
end