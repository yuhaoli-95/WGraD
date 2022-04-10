function figureset(ifGraph, para, Weight, index, NumSam, NumFEs, NumNW, filename, H, P, ifdelete)
FuncID = para.FuncID;
graph_name = [para.FName, '\FuncID', num2str(FuncID),'\'];
if ifGraph & (para.D == 1 | para.D == 2)
    title(['FuncID: ',num2str(FuncID), '    W: ', num2str(Weight), '    # of samples: ', num2str(NumSam), '     evaluation times: ', num2str(NumFEs), '    # of NW: ', num2str(NumNW)]);
    %     set(gcf,'Position',get(0,'ScreenSize'));
    saveas(gcf,[graph_name, 'W', num2str(index), filename]);
    %     if ifdelete
    %         delete(H);delete(P);
    %     end
end
end