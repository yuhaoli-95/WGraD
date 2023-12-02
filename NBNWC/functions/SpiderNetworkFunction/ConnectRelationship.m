function [nodelist, EdgeScore, H, P] = ConnectRelationship(input, output, Weight, ifGraph)
% input = gpuArray(input);
% output = gpuArray(output);
TempSampleNum = length(input(:, 1));
nodelist1 = zeros(TempSampleNum, 2);
EdgeScore = zeros(TempSampleNum, 1);
H = [];
P = [];
for SIth = 1 : TempSampleNum
    %%
    DisScore = (1 : TempSampleNum);
    pointI = input(SIth, :);
    fitnessI = output(SIth);
    %%
    disTemp = sqrt(sum((repmat(pointI, TempSampleNum, 1) - input) .^ 2, 2))';
    DeltaFVTemp = (output - repmat(fitnessI, TempSampleNum, 1))';
    gradientmat = DeltaFVTemp ./ disTemp;
    %%
    mingradient = min(gradientmat);
    maxgradient = max(gradientmat);
    difference = maxgradient - mingradient;
    gradientmat = (TempSampleNum - 1) * ((gradientmat - mingradient) ./ difference) + 1;
    
    disTemp(disTemp == 0) = NaN;
    [~, DisIndex] = sort(disTemp, 'descend');
    DisScore(DisIndex) = DisScore;
    DisScore(isnan(disTemp)) = 0;
    
    disTemp = mapminmax(disTemp, 0, 1);%normalization
    %     ScoreMatT = (1 - Weight) .* gradientmat - Weight .* (disTemp);
    ScoreMatT = (1 - Weight) .* gradientmat + Weight .* (DisScore);
    %%
    ScoreMatT(isnan(ScoreMatT)) = 0;
    [maxscore, tindex] = sort(ScoreMatT, 'descend');
    tindex1 = tindex(1);
    nodelist1(SIth, :) = [SIth, tindex1];
    EdgeScore(SIth) = maxscore(1);
    if ifGraph
        if length(input(1, :)) == 1
            H(SIth) = plot(input(SIth, 1), output(SIth, 1), '.');
            P(SIth) = plot([input(SIth, 1), input(tindex1, 1)], [output(SIth, 1), output(tindex1, 1)], 'b-');
        end
        if length(input(1, :)) == 2
            H(SIth) = plot(input(SIth, 1), input(SIth, 2), '.');
            P(SIth) = plot([input(SIth, 1), input(tindex1, 1)], [input(SIth, 2), input(tindex1, 2)], 'b-');
        end
    end
end
nodelist = nodelist1;
end