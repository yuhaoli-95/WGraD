function [nodelist, nodelist2] = NBC2Climbing(input, output)
theta = 2;
[samnum, Dim] = size(input);
nodelist = zeros(samnum, 3);
% distance matrix of each point
DisGraph = pdist2(input, input);
for samith = 1 : samnum
    Parent = 0;
    disEdge = 0;
    pointI = input(samith, :);
    fitnessI = output(samith);
    disTemp = DisGraph(samith, :);%sqrt(sum((repmat(pointI, samnum, 1) - input) .^ 2, 2))';%euclidean metric
    %         disTemp = sum(abs((repmat(pointI, samnum, 1) - input)) , 2)';%Manhattan Distance
    disTemp(disTemp == 0) = NaN;
    [dismat, disindex] = sort(disTemp);
    % find the nearest-better point
    for disindexIth = 1 : samnum
        if output(disindex(disindexIth)) > fitnessI
            disEdge = dismat(disindexIth);
            Parent = disindex(disindexIth);
            break;
        end
    end
    nodelist(samith, :) = [samith disEdge Parent];
    %%    
    %     DisTemp = DisGraph(samith, :);
    %     DisTemp(samith) = NaN;
    %     FitTemp = output - output(samith);
    %     FitTemp(samith) = nan;
    %     DisTemp(FitTemp < 0) = nan;
    %     [~, NearestBetter] = min(DisTemp);
    %     if isnan(DisTemp)
    %         NearestBetter = -1;
    %         DisEdge = 0;
    %     else
    %         DisEdge = DisTemp(NearestBetter);
    %     end
    %     Parent = NearestBetter;
    %     nodelist(samith, :) = [samith DisEdge Parent];
    
end
nodelist2 = nodelist;
%%
%rule 1
avedis = mean(nodelist(:, 2));
[~, cutedgeindex] = find(nodelist(:, 2)' > theta * avedis);
% point1 = nodelist(cutedgeindex, 1);
% point2 = nodelist(cutedgeindex, 3);
% for cutith = 1 : length(cutedgeindex)
%     plot([input(point1(cutith), 1), input(point2(cutith), 1)], [input(point1(cutith), 2), input(point2(cutith), 2)], 'r-');
% end
nodelist(nodelist(:, 2) > theta * avedis, 3) = -1;
nodelist(nodelist(:, 3) == 0, 3) = -1;
nodelist2(nodelist2(:, 2) > theta * avedis, :) = [];
nodelist2(nodelist2(:, 3) == 0, :) = [];
%%
%rule 2
count1 = 0;
count2 = 0;
b = log10(samnum) * (-0.000469 * Dim ^ 2 + 0.0263 * Dim + 3.66 / Dim - 0.457) + (0.000751 * Dim ^ 2 - 0.0421 * Dim - 2.26 / Dim + 1.83);
for samith = 1 : samnum
    [~, incomenode] = find(nodelist(:, 3)' == samith);
    if length(incomenode) >= 3
        count1 = count1 + 1;
        tempedges = nodelist(incomenode, :);
        meslength = median(tempedges(:, 2));
        if nodelist(nodelist(:, 1) == samith, 2) / meslength > b
            count2 = count2 + 1;
            nodelist(nodelist(:, 1) == samith, 3) = -1;
            nodelist2(nodelist2(:, 1) == samith, :) = [];
        end
    end
end
end