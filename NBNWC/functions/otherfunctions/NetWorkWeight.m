function NWW = NetWorkWeight(NewCluster, ScoreMat, gradientmat, dismat)
%%
%gradient score
GraScoreMat = mapminmax(gradientmat, 0, 1);
%%
%distance score
dismat(dismat == 0) = NaN;
DisScoreMat = mapminmax(dismat, 0, 1);
%%
NWNum = length(NewCluster);
NWW = 0;
if NWNum > 1
    for i = 1 : NWNum
        TCluster = NewCluster;
        NW1 = cell2mat(TCluster(i));
        TCluster(i) = [];
        NW2 = [];
        for j = 1 : length(TCluster)
            NW2 = [cell2mat(TCluster(j)), NW2];
        end
        tg = mean(mean(GraScoreMat(NW1, NW2)));
        td = mean(mean(DisScoreMat(NW1, NW2)));
        %         tweightMat = GraScoreMat(NW1, NW2);
        %         NWW = NWW + sum(sum(tweightMat, 2)) / length(NW1);
        NWW = NWW + (tg - td) / length(NW1);
    end
    NWW = NWW / NWNum;
end
end