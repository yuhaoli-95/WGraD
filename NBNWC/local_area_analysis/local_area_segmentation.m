function local_area_segmentation(reputationIth, FuncID, times, method, gaussian)
global initial_flag
rng(reputationIth);
initial_flag = 0; % should set the flag to 0 for each run, each function
SampleNum = 250 * 1;%get_dimension(FuncID);
folder_name = ['.\', method]; checkFolder(folder_name);
graph_name = [folder_name, '\FuncID', num2str(FuncID), '\']; checkFolder(graph_name);
para = get_para(FuncID, SampleNum, folder_name, times, reputationIth, gaussian);
para = generate_sampleing_point(para);%sampli ng:(1*Dim)parameter | (Dim+1)fitness  sampledata  testdata
%%
if strcmp(method, 'NBC2')
    [networkInfo, para] = NBC2NetworkAnalyze(para, 0);
elseif strcmp(method, 'proDRankGvalue')
    [networkInfo, para] = NetworkAnalyzeFORCuttingAnalysis(para, 1);
elseif strcmp(method, 'approximation')
    [networkInfo, para] = ApproximationNetworkAnalyze(para, 0);
end
save([graph_name, 'run', num2str(reputationIth, '%03d'), 'ClusteringResult.mat']);
display(['function: ', num2str(FuncID), ' reputation: ', num2str(reputationIth, '%02d'), ' # of cluster: ', num2str(length(networkInfo))]);
end