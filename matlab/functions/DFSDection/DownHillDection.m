function Cluster = DownHillDection(input, output, Fid)
% global c
% c = 1;
Visited = zeros(size(output));
Cluster = {};
Heap = [];
count = 1;
ifPlot = 0;
if length(input(1, :)) ~= 2
    ifPlot = 0;
end
while ~all(Visited)
%     open(['10.fig']);
    BestVertex = find(output == max(output(Visited == 0)));
    OpenFigure(num2str(Fid), input, output, count, Cluster, Heap, ifPlot);
    [HeapTemp, TempCluster] = DownHill(Visited, BestVertex(1), input, output, ifPlot, count);
    [Cluster, Heap] = MergeCluster(Cluster, TempCluster, Heap, HeapTemp, input, output);
    Heap = [Heap; HeapTemp];
    Cluster(count) = {TempCluster};
    Visited(cell2mat(Cluster(count))) = 1;
    count = count + 1;
end
end
%another problem: Saddle point will be a local best
function [Heap, Cluster] = DownHill(Visited, V, input, output, ifPlot, countCluster)
Root = V;
Visited(V) = 1;
Cluster = V;
Heap = [];
Edge = [];
VertexNum = length(Visited);
DisTemp = CalculateDistance(input, V, length(Visited));
% DisTemp = pdist2(input, input(V, :))';
DisTemp(V) = nan;
[~, Order] = sort(DisTemp, 'ascend');
Order(Order == Root) = [];
% global c
for i = Order    
    if ~Visited(i)%visit the ith point, and the ith point has not yet been visited
        count = 1;
        %         if ~isempty(Edge)
        %             if sqrt( sum( ( input(V, :) - input(AdjVNode, :)) .^ 2 ) ) > 2 * mean(Edge)
        %                 break;
        %             end
        %         end
        %if the nearest point (AdjVNode) is worse than V, into the while loop
        AdjVNode = i;%find the nearest and unvisited node of V
        [PV, PAdj, L] = PlotNode([], [], [], V, AdjVNode, input, output, ifPlot);
%         saveas(gcf, ['./fig/', num2str(c), '.bmp']);c = c + 1;
        while (output(V) - output(AdjVNode)) >= 0 & Visited(AdjVNode) == 0%(FitGraph(V, AdjVNode) > 0)
            Visited(AdjVNode) = 1;%visit the AdjVnode node
            count = count - 1;
            Cluster = [Cluster; AdjVNode];%add the adjcent worse son node into the cluster.
            Heap = [Heap; V, AdjVNode];%connect V and AdjVNode
            Edge = [Edge; sqrt( sum( ( input(V, :) - input(AdjVNode, :)) .^ 2 ) )];
            Parent = V;
            V = AdjVNode;%go to AdjVNode
            AdjVNode = FindAdjVNode(V, Root, Visited, input);%find the nearest and unvisited node of V
            [PV, PAdj, L] = PlotNode(PV, PAdj, [], V, AdjVNode, input, output, ifPlot);
%             saveas(gcf, ['./fig/', num2str(c), '.bmp']);c = c + 1;
        end
        PlotNode(PV, PAdj, L, Root, [], input, output, ifPlot);
%         saveas(gcf, ['./fig/', num2str(c), '.bmp']);c = c + 1;
        %if count == 0, which means that Root > 1th < 2th
        %check the edge between the root and 1th
        %if there is a valley, delete the 1th point
        if ~count
            if AdjVNode ~= Root
                %Uphill to another local best
                DisTemp = CalculateDistance(input, V, length(Visited));
                DisTemp(Visited == 1) = nan;
                %detect boundary point
                a = input(AdjVNode, :) - input(V, :);
                b = input - input(AdjVNode, :);
                Dot = sum(b .* a, 2);
                %Angle < 0, means that the directions of V1 and V2 are opposite. set them to nan.
                DisTemp(Dot < 0) = nan;
                Visited(~isnan(DisTemp)) = 1;
                MarkOtherNode(DisTemp, input, output, V, ifPlot);
%                 saveas(gcf, ['./fig/', num2str(c), '.bmp']);c = c + 1;
            end
        end
        %V returns to Root
        V = Root;
    end
end
end

function AdjVNode = FindAdjVNode(V, Parent, Visited, input)
DisTemp = CalculateDistance(input, V, length(Visited));
% DisTemp = pdist2(input, input(V, :))';
DisTemp(Visited == 1) = nan;
%detect boundary point
a = input(V, :) - input(Parent, :);
b = input - input(V, :);
Dot = sum(b .* a, 2);
%Angle < 0, means that the directions of V1 and V2 are opposite. set them to nan.
DisTemp(Dot < 0) = nan;
%Dot1 = a dot b = |a||b|cos(<a, b>), Dot2 = a dot c = |a||c|cos(<a, c>),
%so if Dot1 > Dot2, |b|cos(<a, b>) > |c|cos(<a, c>)
% Angle = acosd(Dot ./ (NormVector(b, 2)) ./ (NormVector(a, 2)));
% Dot(Dot < 0) = nan;
%
[~, AdjVNode] = min(DisTemp);
if isnan(DisTemp)
    AdjVNode = Parent;
end
end

function DisTemp = CalculateDistance(input, V, VertexNum)
% Dim = length(input(1, :));
% Temp = zeros(size(input));
% for i = 1 : Dim
%     Temp(:, i) = mapminmax(input(:, i)', 0, 1)';
% end
% input = Temp;
DisTemp = sqrt(sum((repmat(input(V, :), VertexNum, 1) - input) .^ 2, 2))';%euclidean metric;
end

function [Cluster, Heap] = MergeCluster(Cluster, TempCluster, Heap, HeapTemp, input, output)
if isempty(Cluster)
    return;
end
NC = length(Cluster);%# of Clusters
Dim = length(input(1, :));
Roots = zeros(NC, Dim);
RootsIndex = zeros(NC + 1, 1);
for i = 1 : NC
    t = cell2mat(Cluster(i));
    [~, RootsIndex(i)] = max(output(t));
    RootsIndex(i) = t(RootsIndex(i));
    Roots(i, :) = input(RootsIndex(i), :);
end
[~, RootsIndex(end)] = max(output(TempCluster));
RootsIndex(end) = TempCluster(RootsIndex(end));
TempRoot = input(RootsIndex(end), :);
for i = 1 : NC
    P1 = TempRoot;
    P2 = Roots(i, :);
    lb = min([P1; P2]);
    ub = max([P1; P2]);
    PointSIndex = ones(size(output));
    PointSIndex([RootsIndex(i), RootsIndex(end)]) = 0;
    for j = 1 : Dim
        PointSIndex(input(:, j) < lb(j)) = 0;
        PointSIndex(input(:, j) > ub(j)) = 0;
    end
    v = P2 - P1;
    PointSIndex = find(PointSIndex == 1);
    if isempty(PointSIndex) | length(PointSIndex) == 1
        find_valley = 1;
        continue;
    end
    u = input(PointSIndex, :);
    Dis = abs(sum(u .* v, 2) ./ norm(v));
    [~, DisIndex] = sort(Dis, 'ascend');
    u = u(DisIndex, :);
    PointSIndex = PointSIndex(DisIndex);
    find_valley = 0;
    for j = 1 : length(PointSIndex) - 1
        if output(j) < output(j + 1)
            find_valley = 1;
            break;
        end
    end
end
if find_valley
    Cluster(end + 1) = {TempCluster};
    Heap = [Heap; HeapTemp];
    return;
else
    t = cell2mat(Cluster(i));
    Cluster(i) = {[t; TempCluster]};
    Heap = [Heap; RootsIndex(end) RootsIndex(i); HeapTemp];
end
end

function OpenFigure(Fid, input, output, count, Cluster, Heap, ifPlot)
if ifPlot
%     close all;
%     open([Fid, '.fig']);
%     global c
    if length(input(1, :)) == 1
        plot(input, output, 'rO');hold on
        for i = count - 1 : -1 : 1
            plot(input(cell2mat(Cluster(i))), output(cell2mat(Cluster(i))), 'k.', 'MarkerSize', 15);
            for line = 1 : length(Heap(:, 1))
                P1 = Heap(line, 1);
                P2 = Heap(line, 2);
                plot([input(P1) input(P2)], [output(P1) output(P2)], 'k');
            end
        end
    elseif length(input(1, :)) == 2
        plot(input(:, 1), input(:, 2), 'rO');hold on
        for i = count - 1 : -1 : 1
            plot(input(cell2mat(Cluster(i)), 1), input(cell2mat(Cluster(i)), 2), '.', 'MarkerSize', 10);
            for line = 1 : length(Heap(:, 1))
                P1 = Heap(line, 1);
                P2 = Heap(line, 2);
                plot([input(P1, 1) input(P2, 1)], [input(P1, 2) input(P2, 2)], 'b');
            end
        end
    end
%     saveas(gcf, ['./fig/', num2str(c), '.bmp']); c = c + 1;
end
end

function [PV, PAdj, L] = PlotNode(PV, PAdj, L, V, AdjVNode, input, output,ifPlot)
if ifPlot
    if ~isempty(PV); delete(PV); end
    if ~isempty(PAdj); delete(PAdj); end
    if ~isempty(L); delete(L); end
    PV = []; PAdj= []; L = [];
    if ~isempty(V)
        if length(input(1, :)) == 1
            plot(input(V), output(V), 'k.', 'MarkerSize', 20);
            PV = plot(input(V), output(V), 'kP', 'MarkerSize', 3, 'LineWidth', 3);
        elseif length(input(1, :)) == 2
            plot(input(V, 1), input(V, 2), 'r.', 'MarkerSize', 20);
            PV = plot(input(V, 1), input(V, 2), 'kP', 'MarkerSize', 3, 'LineWidth', 3);
        end
    end
    if ~isempty(AdjVNode)
        if length(input(1, :)) == 1
            PAdj = plot(input(AdjVNode), output(AdjVNode), 'bP', 'MarkerSize', 10);
        elseif length(input(1, :)) == 2
            PAdj = plot(input(AdjVNode, 1), input(AdjVNode, 2), 'bP', 'MarkerSize', 10);
        end
    end
    if ~isempty(V) & ~isempty(AdjVNode)
        if length(input(1, :)) == 1
            L = plot([input(V) input(AdjVNode)], [output(V) output(AdjVNode)], 'r', 'LineWidth', 2);
        elseif length(input(1, :)) == 2
            L = plot([input(V, 1) input(AdjVNode, 1)], [input(V, 2) input(AdjVNode, 2)], 'b');
        end
    end
end
end

function Visited = DetectBoundaryPoint(V, AdjVNode, input, output, Visited, ifPlot)
%Uphill to another local best
DisTemp = CalculateDistance(input, V, length(Visited));
DisTemp(Visited == 1) = nan;
%detect boundary point
a = input(AdjVNode, :) - input(V, :);
b = input - input(AdjVNode, :);
Dot = sum(b .* a, 2);
%Angle < 0, means that the directions of V1 and V2 are opposite. set them to nan.
DisTemp(Dot < 0) = nan;
Visited(~isnan(DisTemp)) = 1;
MarkOtherNode(DisTemp, input, output, V, ifPlot);
end

function MarkOtherNode(DisTemp, input, output, V, ifPlot)
if ifPlot
    TempNode = 1 : length(DisTemp);
    TempNode = TempNode(~isnan(DisTemp));
    if length(input(1, :)) == 1
        plot(input(V), output(V), 'bX', 'MarkerSize', 12, 'LineWidth', 3);
        plot(input(TempNode), output(TempNode), 'bS', 'MarkerSize', 10);
    elseif length(input(1, :)) == 2
        plot(input(V, 1), input(V, 2), 'bX', 'MarkerSize', 12, 'LineWidth', 3);
        plot(input(TempNode, 1), input(TempNode, 2), 'bS', 'MarkerSize', 10);
    end
end
end
