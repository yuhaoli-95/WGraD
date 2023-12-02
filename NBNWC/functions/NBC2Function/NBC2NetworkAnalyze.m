function [networkInfo, para] = NBC2NetworkAnalyze(para, ifGraph)
input       = para.AnalysisData(:, 1 : end - 1);
output      = para.AnalysisData(:, end);
count       = 0;
%%
% plot_Landscape(para, 0, 0, 1);
% open('Func7_contour.fig');hold on;plot(para.AnalysisData(:, 1), para.AnalysisData(:, 2), '.');
nodelist = NBC2(input, output, ifGraph);
nodelist = nodelist(:, [1 3]);
% for ith = 1 : length(nodelist(:, 1))
%     SIth = nodelist(ith, 1);
%     tindex1 = nodelist(ith, 2);
%     P(SIth) = plot([input(SIth, 1), input(tindex1, 1)], [input(SIth, 2), input(tindex1, 2)], 'b-');
% end
NewNetWork = ConnectNetWork(nodelist);
% for newNWi = 1 : length(NewNetWork)
%     temp = cell2mat(NewNetWork(newNWi));
%     plot(input(temp, 1), input(temp, 2), 'o');
% end
%%
networkInfo = NewNetWork;
para.sampledata = [input output];
para.FEs = count;
[networkInfo, NWScore] = NetworkEvaluation(networkInfo, para);
para.NWScore = NWScore;
end