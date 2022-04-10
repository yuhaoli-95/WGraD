function Cluster = CreateHeap(nodelist, NodeNum)
CheckList = nodelist(:, 1) - nodelist(:, 2);
if ~all(CheckList)
    nodelist(~CheckList, 2) = -1;
end
for i = 1 : NodeNum
    T = nodelist(i, 1);
    Path = [T];
    while nodelist(T, 2) ~= -1
        T = nodelist(T, 2);
        Path = [Path T];
    end
    Path(end) = [];
    nodelist(Path, 2) = T;
end
Root = find(nodelist(:, 2) == -1)';
i = 1;
NodeNum = zeros(length(Root), 1);
for root = Root
    Node = [root, find(nodelist(:, 2) == root)'];
    Node = sort(Node);
    Cluster(i) = {Node};
    NodeNum(i) = length(Node);
    i = i + 1;
end
%delete the cluster that has only one node
[~, Order] = find(NodeNum' == 1);
Merge = cell2mat(Cluster(Order));
Cluster(end + 1) = {Merge};
NodeNum(end + 1) = length(Merge);
Cluster(NodeNum == 1) = [];
NodeNum(NodeNum == 1) = [];
Cluster(cellfun(@isempty, Cluster))=[];
NodeNum(NodeNum == 0) = [];
[~, Order] = sort(NodeNum);
Cluster = Cluster(Order);
end