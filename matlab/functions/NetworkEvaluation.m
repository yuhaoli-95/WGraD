function [networkInfo, NWScore] = NetworkEvaluation(networkInfo, para)
NumNW = length(networkInfo);
Score = zeros(1, NumNW);
for NWIth = 1 : NumNW
    tempnew = cell2mat(networkInfo(NWIth));
    Score(NWIth) = length(tempnew);
end
[NWScore, Index] = sort(Score, 'descend');
networkInfo = networkInfo(Index);
end