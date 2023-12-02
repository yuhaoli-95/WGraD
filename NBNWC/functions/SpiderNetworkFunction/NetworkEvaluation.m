function [networkInfo, NWScore] = NetworkEvaluation(networkInfo, para)
% calculate "score" of each sub-graph and sort them by the score
%%
sample = para.sampledata;
NumNW = length(networkInfo);
NWstd = zeros(1, NumNW);
Score = zeros(1, NumNW);
% graph_name = [para.FName, '\FuncID', num2str(para.FuncID),'\'];
for NWIth = 1 : NumNW
    % indices of samples of the NWIth sub-graph
    tempnew = cell2mat(networkInfo(NWIth)); 
    sampleTemp = sample(tempnew, :);
    smpFVTemp = sampleTemp(:, end);
    NWstd(NWIth) = std(smpFVTemp);
    Score(NWIth) = NWstd(NWIth) * length(tempnew);
end
[NWScore, Index] = sort(Score, 'descend');
networkInfo = networkInfo(Index);
% if length(sample(1, :)) == 3
%     plot_Landscape(para, 0, 0);
%     title(['FuncID: ',num2str(para.FuncID), '    # of NW: ', num2str(NumNW)]);
%     for NWIth = 1 : NumNW
%         tempnew = cell2mat(networkInfo(NWIth));
%         sampleTemp = sample(tempnew, :);
%         plot(sampleTemp(:, 1), sampleTemp(:, 2), 'o');
%         saveas(gcf,[graph_name, 'FinalVideo_NW', num2str(NWIth), 'th.bmp']);
%     end
%     close all
% end
end