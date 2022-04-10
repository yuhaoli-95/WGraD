function [nodelist1, nodelist2, H, P, EdgeScore] = WGraD2Climbing(input, output)
% input = gpuArray(input);
% output = gpuArray(output);
samnum = length(input(:, 1));
nodelist1 = zeros(samnum, 2);
nodelist2 = zeros(samnum, 2);
EdgeScore = zeros(samnum, 1);
H = [];
P = [];
% DisGraph = pdist2(input, input);
for samith = 1 : samnum
    %%
    pointI = input(samith, :);
    fitnessI = output(samith);
    %%
    %DisGraph(samith, :);%
    disTemp = sqrt(sum((repmat(pointI, samnum, 1) - input) .^ 2, 2))';%euclidean metric
    DisGraph = disTemp;
    %     disTemp = sum(abs(repmat(pointI, samnum, 1) - input) , 2)';%Manhattan Distance
    DeltaFVTemp = (output - fitnessI)';
    gradientmat = DeltaFVTemp ./ disTemp;
    %%
    gradientmat = ((gradientmat - min(gradientmat)) / (max(gradientmat) - min(gradientmat)));
    disTemp(disTemp == 0) = NaN;
    disTemp = ((disTemp - min(disTemp)) / (max(disTemp) - min(disTemp))); %(TempSampleNum - 1) * 
    Weight = disTemp;
    ScoreMatT = (1 - Weight) .* gradientmat - Weight .* (disTemp);
    %%
    ScoreMatT(isnan(disTemp)) = nan;
    [maxscore, tindex] = max(ScoreMatT);
    tindex1 = tindex;
    if output(samith) == output(tindex)
        output(samith) = output(samith) + 10^-13;
    end
    if output(samith) > output(tindex)
        tindex1 = -1;
    end
    nodelist1(samith, :) = [samith, tindex];
    nodelist2(samith, :) = [samith, tindex1];
    if samith == tindex1
        aa = 1;
    end
    EdgeScore(samith) = DisGraph(tindex);
end
end