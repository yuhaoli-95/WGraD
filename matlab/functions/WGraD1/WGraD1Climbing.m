function [nodelist, EdgeDis] = WGraD1Climbing(input, output, Weight)
% input = gpuArray(input);
% output = gpuArray(output);
samnum = length(input(:, 1));
nodelist1 = zeros(samnum, 2);
EdgeDis = zeros(samnum, 1);
DisGraph = pdist2(input, input);
for samith = 1 : samnum
    %%
    DisScore = (1 : samnum) / samnum;
    pointI = input(samith, :);
    fitnessI = output(samith);
    %%
    disTemp = DisGraph(samith, :);
    disTemp1 = sqrt(sum((repmat(pointI, samnum, 1) - input) .^ 2, 2))';%euclidean metric
    if sum(disTemp-disTemp1)==0
        b=1;
    else
        a=1;
    end
    %     disTemp = sum(abs(repmat(pointI, samnum, 1) - input) , 2)';%Manhattan Distance
    DeltaFVTemp = (output - fitnessI)';
    gradientmat = DeltaFVTemp ./ disTemp;
    %%
    mingradient = min(gradientmat);
    maxgradient = max(gradientmat);
    difference = maxgradient - mingradient;
    gradientmat = (gradientmat - mingradient) / difference;
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
    disTempT = (maxdistance - disTemp) / Disdifference;
    ScoreMatT = (1 - Weight) * gradientmat + Weight * (disTempT);% min(gradientmat) max(gradientmat)
    %%
    ScoreMatT(isnan(ScoreMatT)) = 0;
    [maxscore, tindex] = max(ScoreMatT);
    nodelist1(samith, :) = [samith, tindex];
    EdgeDis(samith) = DeltaFVTemp(tindex);
end
nodelist = nodelist1;
end