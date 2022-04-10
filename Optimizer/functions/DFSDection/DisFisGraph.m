function [DisGraph, FitGraph] = DisFisGraph(input, output)
VertexNum = length(output);
FitGraph = repmat(output, 1, VertexNum) - repmat(output', VertexNum, 1);
SearchPoint = [input, output];
% Graph.Distance = pdist2(SearchPoint, SearchPoint);
DisGraph = pdist2(input, input);
DisGraph(logical( eye( size(DisGraph) ) ) ) = nan;
end