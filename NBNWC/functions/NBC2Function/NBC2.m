function nodelist = NBC2(input, output, ifGraph)
theta = 2;
[samnum, Dim] = size(input);
nodelist = zeros(samnum, 3);
for samith = 1 : samnum
    connextindex = 0;
    disEdge = 0;
    pointI = input(samith, :);
    fitnessI = output(samith);
    disTemp = sqrt(sum((repmat(pointI, samnum, 1) - input) .^ 2, 2))';
    disTemp(disTemp == 0) = NaN;
    [dismat, disindex] = sort(disTemp);
    for disindexIth = 1 : samnum
        if output(disindex(disindexIth)) > fitnessI
            disEdge = dismat(disindexIth);
            connextindex = disindex(disindexIth);            
            if ifGraph
                if length(input(1, :)) == 2
                    H(samith) = plot(input(samith, 1), input(samith, 2), '.');
                    P(samith) = plot([input(samith, 1), input(connextindex, 1)], [input(samith, 2), input(connextindex, 2)], 'b-');
                end
            end
            break;
        end
    end
    nodelist(samith, :) = [samith disEdge connextindex ];
end
%%
%rule 1
avedis = mean(nodelist(:, 2));
[~, cutedgeindex] = find(nodelist(:, 2)' > theta * avedis);
% point1 = nodelist(cutedgeindex, 1);
% point2 = nodelist(cutedgeindex, 3);
% for cutith = 1 : length(cutedgeindex)
%     plot([input(point1(cutith), 1), input(point2(cutith), 1)], [input(point1(cutith), 2), input(point2(cutith), 2)], 'r-');
% end
nodelist(nodelist(:, 2) > theta * avedis, :) = [];
nodelist(nodelist(:, 3) == 0, :) = [];
%%
%rule 2
b = log10(samnum) * (-0.000469 * Dim ^ 2 + 0.0263 * Dim + 3.66 / Dim - 0.457) + (0.000751 * Dim ^ 2 - 0.0421 * Dim - 2.26 / Dim + 1.83);
for samith = 1 : samnum
    [~, incomenode] = find(nodelist(:, 3)' == samith);
    if length(incomenode) >= 3
        tempedges = nodelist(incomenode, :);
        meslength = median(tempedges(:, 2));
        if nodelist(nodelist(:, 1) == samith, 2) / meslength > b
            nodelist(nodelist(:, 1) == samith, :) = [];
        end
    end
end

end