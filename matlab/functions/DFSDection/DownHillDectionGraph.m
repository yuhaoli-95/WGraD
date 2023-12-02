function Cluster = DownHillDectionGraph(DisGraph, FitGraph, input, output, Fid)
Visited = zeros(size(output));
Cluster = {};
Heap = [];
count = 1;
ifPlot = 0;
while ~all(Visited)
    BestVertex = find(output == max(output(Visited == 0)));
    OpenFigure(Fid, input, count, Cluster, Heap, ifPlot)
    [HeapTemp, TempCluster] = DownHill(DisGraph, FitGraph, Visited, BestVertex, input, ifPlot);
    Heap = [Heap; HeapTemp];
    Cluster(count) = {TempCluster};
    Visited(cell2mat(Cluster(count))) = 1;
    count = count + 1;
    %close all;
end
end
%another problem: Saddle point will be a local best
function [Heap, Cluster] = DownHill(DisGraph, FitGraph, Visited, V, input, ifPlot)
Root = V;
Visited(V) = 1;
Cluster = V;
Heap = [];
[~, Order] = sort(DisGraph(Root, :), 'ascend');
Order(Order == Root) = [];
for i = Order
    if ~Visited(i)%visit the ith point, and the ith point has not yet been visited
        count = 1;
        %if the nearest point (AdjVNode) is worse than V, into the while loop
        AdjVNode = i;%find the nearest and unvisited node of V
        [PV, PAdj, L] = PlotNode([], [], [], V, AdjVNode, input, ifPlot);
        while (FitGraph(V, AdjVNode) > 0)
            Visited(AdjVNode) = 1;%visit the AdjVnode node
            count = count - 1;
            Cluster = [Cluster; AdjVNode];%add the adjcent worse son node into the cluster.
            Heap = [Heap; V, AdjVNode];%connect V and AdjVNode
            Parent = V;
            V = AdjVNode;%go to AdjVNode
            AdjVNode = FindAdjVNode(DisGraph, V, Parent, Visited, input);%find the nearest and unvisited node of V
            [PV, PAdj, L] = PlotNode(PV, PAdj, [], V, AdjVNode, input, ifPlot);
        end
        PlotNode(PV, PAdj, L, Root, [], input, ifPlot);
        %if count == 0, which means that Root > 1th < 2th
        %check the edge between the root and 1th
        %if there is a valley, delete the 1th point
        if ~count
            if AdjVNode ~= Root
                %Uphill to another local best
                DisTemp = DisGraph(V, :);
                DisTemp(Visited == 1) = nan;
                %detect boundary point
                a = input(AdjVNode, :) - input(V, :);
                b = input - input(AdjVNode, :);
                Dot = sum(b .* a, 2);
                %Angle < 0, means that the directions of V1 and V2 are opposite. set them to nan.
                DisTemp(Dot < 0) = nan;
                Visited(~isnan(DisTemp)) = 1;
                %
                MarkOtherNode(DisTemp, input, V, ifPlot);
            end
            %             while FitGraph(V, AdjVNode) < 0
            %                 Visited(AdjVNode) = 1;%visit the AdjVnode node
            %                 plot(input(AdjVNode, 1), input(AdjVNode, 2), 'bS', 'MarkerSize', 10);
            %                 Parent = V;
            %                 V = AdjVNode;%go to the AdjVNode
            %                 AdjVNode = FindAdjVNode(DisGraph, V, Parent, Visited, input);%find the nearest and unvisited node of V
            %             end
            %             %Downhill from the other side
            %             plot(input(V, 1), input(V, 2), 'bS', 'MarkerSize', 10);
            %             while FitGraph(V, AdjVNode) > 0
            %                 Visited(AdjVNode) = 1;%visit the AdjVnode node
            %                 plot(input(AdjVNode, 1), input(AdjVNode, 2), 'bS', 'MarkerSize', 10);
            %                 Parent = V;
            %                 V = AdjVNode;%go to the AdjVNode
            %                 AdjVNode = FindAdjVNode(DisGraph, V, Parent, Visited, input);%find the nearest and unvisited node of V
            %             end
        end
        %V returns to Root
        V = Root;
    end
end
end

function AdjVNode = FindAdjVNode(DisGraph, V, Parent, Visited, input)
DisTemp = DisGraph(V, :);
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

function OpenFigure(Fid, input, count, Cluster, Heap, ifPlot)
if ifPlot
    close all;
    open([num2str(Fid), '.fig']);plot(input(:, 1), input(:, 2), 'O');hold on
    for i = count - 1 : -1 : 1
        plot(input(cell2mat(Cluster(i)), 1), input(cell2mat(Cluster(i)), 2), '.', 'MarkerSize', 10);
        for line = 1 : length(Heap(:, 1))
            P1 = Heap(line, 1);
            P2 = Heap(line, 2);
            plot([input(P1, 1) input(P2, 1)], [input(P1, 2) input(P2, 2)], 'b');
        end
    end
end
end

function [PV, PAdj, L] = PlotNode(PV, PAdj, L, V, AdjVNode, input, ifPlot)
if ifPlot
    if ~isempty(PV); delete(PV); end
    if ~isempty(PAdj); delete(PAdj); end
    if ~isempty(L); delete(L); end
    PV = []; PAdj= []; L = [];
    if ~isempty(V)
        plot(input(V, 1), input(V, 2), 'r.', 'MarkerSize', 20);
        PV = plot(input(V, 1), input(V, 2), 'kP', 'MarkerSize', 3, 'LineWidth', 3);
    end
    if ~isempty(AdjVNode)
        PAdj = plot(input(AdjVNode, 1), input(AdjVNode, 2), 'bP', 'MarkerSize', 10);
    end
    if ~isempty(V) & ~isempty(AdjVNode)
        L = plot([input(V, 1) input(AdjVNode, 1)], [input(V, 2) input(AdjVNode, 2)], 'b');
    end
end
end

function MarkOtherNode(DisTemp, input, V, ifPlot)
if ifPlot
    TempNode = 1 : length(DisTemp);
    TempNode = TempNode(~isnan(DisTemp));
    plot(input(V, 1), input(V, 2), 'bX', 'MarkerSize', 12, 'LineWidth', 3);
    plot(input(TempNode, 1), input(TempNode, 2), 'bS', 'MarkerSize', 10);
end
end

function Norm = NormVector(X, p)
Norm = sum(abs(X) .^ p, 2) .^ (1/p);
end