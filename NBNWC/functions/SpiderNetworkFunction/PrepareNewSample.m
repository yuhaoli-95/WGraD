function insertpoint = PrepareNewSample(PA, PB, PC, SampleNum, Dim)
disBA = sqrt(sum((PA - PB).^2));
VecBA = (PA - PB) / disBA;
disBC = sqrt(sum((PC - PB).^2));
uVBD = VecBA * disBC;
InsertNum = floor(disBA / (disBC));
%%
if InsertNum < SampleNum
    InsertVec = repmat(uVBD, InsertNum, 1) .* repmat([1 : InsertNum]', 1, Dim);
    insertpoint = InsertVec + repmat(PB, InsertNum, 1);
else
    num = 3;
    VecBA = (PA - PB) / num;
    InsertVec = repmat(VecBA, num - 1, 1) .* repmat([1 : num - 1]', 1, Dim);
    insertpoint = InsertVec + repmat(PB, num - 1, 1);
end
%%
% if halfdisBC < disBA & InsertNum < SampleNum
%     InsertVec = repmat(uVBD, InsertNum, 1) .* repmat([1 : InsertNum]', 1, Dim);
%     insertpoint = InsertVec + repmat(PB, InsertNum, 1);
% else
%     num = 3;
%     VecBA = (PA - PB) / num;
%     InsertVec = repmat(VecBA, num - 1, 1) .* repmat([1 : num - 1]', 1, Dim);
%     insertpoint = InsertVec + repmat(PB, num - 1, 1);
% end
end