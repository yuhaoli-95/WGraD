function [nodelist1, nodelist2, H, P, EdgeScore] = WGraD2Climbing(input, output)
samnum = length(input(:, 1));
nodelist1 = zeros(samnum, 2);
nodelist2 = zeros(samnum, 2);
EdgeScore = zeros(samnum, 1);
H = [];
P = [];
% DisGraph = pdist2(input, input);
for samith = 1 : samnum
    if samith == 65
        a = 1;
    end
    %%
    pointI = input(samith, :);
    fitnessI = output(samith);
    %%
    % calculate distance matrix between the i-th point and the others
    disTemp = sqrt(sum((repmat(pointI, samnum, 1) - input) .^ 2, 2))';%euclidean metric
    DisGraph = disTemp;
    %     disTemp = sum(abs(repmat(pointI, samnum, 1) - input) , 2)';%Manhattan Distance
    % calculate gradient matrix between the i-th point and the others
    DeltaFVTemp = (output - fitnessI)';
    gradientmat = DeltaFVTemp ./ disTemp;
    %%
    % calculate score matrix between the i-th point and the others
    gradientmat = ((gradientmat - min(gradientmat)) / (max(gradientmat) - min(gradientmat)));
    disTemp(disTemp == 0) = NaN;
    disTemp = ((disTemp - min(disTemp)) / (max(disTemp) - min(disTemp))); %(TempSampleNum - 1) * 
    Weight = disTemp;
    ScoreMatT = (1 - Weight) .* gradientmat - Weight .* (disTemp);
    %%
    % find the suitable point of the i-th point
    ScoreMatT(isnan(disTemp)) = nan;
    % tindex: the index of the suitable point
    [maxscore, tindex] = max(ScoreMatT);
    tindex1 = tindex;
    if output(samith) == output(tindex)
        output(samith) = output(samith) + 10^-13;
    end
    % if the i-th point is better than the tindex-th point, the edge should
    % be ith -> -1
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