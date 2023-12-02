function [nodelist, EdgeScore, H, P] = ApproximationConnectRelationship(input, output, Weight, ifGraph)
% Choose the most suitable point for each sample point and connect them with edges.
% input: 
%   input: solution info list
%   output: the fitness of solutions
%   weight: current weight between distance and gradient
%   ifGraph: save fig
% output: 
%   nodelist: edge info, [the i-th point index, the connected sample index]
%   EdgeScore: selected edge score of the i-th edge
%   H: plot info
%   P: plot info
%% 
% input = gpuArray(input);
% output = gpuArray(output);
TempSampleNum = length(input(:, 1));
nodelist1 = zeros(TempSampleNum, 2);
EdgeScore = zeros(TempSampleNum, 1);
H = [];
P = [];
for SIth = 1 : TempSampleNum
    %% Each sample point selects its most suitable point according to the paper
    DisScore = (1 : TempSampleNum) / TempSampleNum;
    GraScore = 1 : TempSampleNum;
    pointI = input(SIth, :);
    fitnessI = output(SIth);
    %% Calculate the distance and gradient between the i-th point and other points.
    disTemp = sqrt(sum((repmat(pointI, TempSampleNum, 1) - input) .^ 2, 2))';
    DeltaFVTemp = (output - repmat(fitnessI, TempSampleNum, 1))';
    gradientmat = DeltaFVTemp ./ disTemp;
    %%
    % normalize gradient info
    gradientmat = (1) * ((gradientmat - min(gradientmat)) ./ (max(gradientmat) - min(gradientmat)));
    
    disTemp(disTemp == 0) = NaN;
    % [~, DisIndex] = sort(disTemp, 'descend');
    % DisScore(DisIndex) = DisScore;
    % DisScore(isnan(disTemp)) = 0;
    %     disTemp = (TempSampleNum - 1) * ((disTemp - min(disTemp)) ./ (max(disTemp) - min(disTemp)));
    %     disTemp = (TempSampleNum - 1) - disTemp;
    disTemp = mapminmax(disTemp, 0, 1);%normalization
    WeightT = Weight .* (disTemp);
    ScoreMatT = (1 - WeightT) .* gradientmat - WeightT .* (disTemp);
    %% select the best one
    ScoreMatT(isnan(ScoreMatT)) = 0;
    [maxscore, tindex] = sort(ScoreMatT, 'descend');
    tindex1 = tindex(1);
    nodelist1(SIth, :) = [SIth, tindex1];
    EdgeScore(SIth) = maxscore(1);
    if ifGraph
        if length(input(1, :)) == 2
            H(SIth) = plot(input(SIth, 1), input(SIth, 2), '.');
            P(SIth) = plot([input(SIth, 1), input(tindex1, 1)], [input(SIth, 2), input(tindex1, 2)], 'b-');
        end
    end
end
% nodelist: [the i-th point index, the connected sample index]
nodelist = nodelist1;
end