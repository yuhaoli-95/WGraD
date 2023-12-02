function [fes, BestIndiArray, ClusterN] = TwoStageNichingAlgorithm(fes, BestIndiArray, method, ClusterPara, opti_para)
tic
ClusterPara = GenerateSamples(ClusterPara);%sampling:(1*Dim)parameter | (Dim+1)fitness  sampledata  testdata
% NWPara.AnalysisData = [NWPara.AnalysisData; sample];
%%
% NBC2, WGraD1 and WGraD2 have the same framework to get spanning trees:
% 1. [nodelist, nodelist2] = XXXXClimbing(input, output);
%   'nodelist' and 'nodelist2 ' are the adjacency matrix: [index of start point, distance, index of end point]
%   each row is an directed edge with distance
% 2. NewNetWork = CreateHeap(nodelist, length(output));
%   find sub-graphs using DFS(Depth-First-Search) algotighm
ClusterPara.FEs = 0;
if strcmp(method, 'NBC2')
    [networkInfo, ClusterPara] = NBC2(ClusterPara);
elseif strcmp(method, 'WGraD1')
    [networkInfo, ClusterPara] = WGraD1(ClusterPara);
elseif strcmp(method, 'WGraD2')
    [networkInfo, ClusterPara] = WGraD2(ClusterPara);
elseif strcmp(method, 'Switch1')
    [networkInfo1, ClusterPara] = NBC2(ClusterPara);
    [networkInfo2, ClusterPara] = WGraD1(ClusterPara);
    if length(networkInfo2) > length(networkInfo1)
        networkInfo = networkInfo2;
    else
        networkInfo = networkInfo1;
    end
elseif strcmp(method, 'Switch2')
    [networkInfo1, ClusterPara] = NBC2(ClusterPara);
    [networkInfo2, ClusterPara] = WGraD2(ClusterPara);
    if length(networkInfo2) > length(networkInfo1)
        networkInfo = networkInfo2;
    else
        networkInfo = networkInfo1;
    end
elseif strcmp(method, 'Comb1')
    [networkInfo, ClusterPara] = Comb1(ClusterPara);
elseif strcmp(method, 'Comb2')
    [networkInfo, ClusterPara] = Comb2(ClusterPara);
elseif strcmp(method, 'DHD')
    [networkInfo, ClusterPara] = DHD(ClusterPara);
end
fes = fes + ClusterPara.FEs + ClusterPara.SampleNum;
opti_para.sampledata = ClusterPara.sampledata;
ClusterN = length(networkInfo);
[BestIndiArray, fes] = ObtainMultipleOptima(BestIndiArray, fes, networkInfo, opti_para);
end
