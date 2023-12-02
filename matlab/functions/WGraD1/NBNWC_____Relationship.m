function [nodelist, EdgeScore] = NBNWCRelationship(input, output, Weight)
% input = gpuArray(input);
% output = gpuArray(output);
samnum = length(input(:, 1));
nodelist1 = zeros(samnum, 2);
EdgeScore = zeros(samnum, 1);
parfor SIth = 1 : samnum
    %%
    DisScore = (1 : samnum);
    pointI = input(SIth, :);
    fitnessI = output(SIth);
    %%
    %     disTemp = sqrt(sum((repmat(pointI, TempSampleNum, 1) - input) .^ 2, 2))';%euclidean metric
    disTemp = sum((repmat(pointI, samnum, 1) - input) , 2);%Manhattan Distance
    DeltaFVTemp = (output - repmat(fitnessI, samnum, 1))';
    gradientmat = DeltaFVTemp ./ disTemp;
    %%
    mingradient = min(gradientmat);
    maxgradient = max(gradientmat);
    difference = maxgradient - mingradient;
    gradientmat = (samnum - 1) * ((gradientmat - mingradient) ./ difference) + 1;
    %%
    %     disTemp(disTemp == 0) = NaN;
    %     [~, DisIndex] = sort(disTemp, 'descend');
    %     DisScore(DisIndex) = DisScore;
    %     DisScore(isnan(disTemp)) = 0;
    %     ScoreMatT = (1 - Weight) .* gradientmat + Weight .* (DisScore);
    %%
    disTemp(disTemp == 0) = NaN;
    mindistance = min(disTemp);
    maxdistance = max(disTemp);
    Disdifference = maxdistance - mindistance;
    disTempT = (samnum - 1) * ((maxdistance - disTemp) ./ Disdifference) + 1;
    ScoreMatT = (1 - Weight) .* gradientmat + Weight .* (disTempT);% min(gradientmat) max(gradientmat)
    %%
    ScoreMatT(isnan(ScoreMatT)) = 0;
    [maxscore, tindex] = sort(ScoreMatT, 'descend');
    tindex1 = tindex(1);
    nodelist1(SIth, :) = [SIth, tindex1];
    EdgeScore(SIth) = maxscore(1);
end
nodelist = nodelist1;
end