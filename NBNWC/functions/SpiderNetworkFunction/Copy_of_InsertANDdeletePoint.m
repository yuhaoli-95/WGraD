function [InsertPoint, insertpointFV, count, deletlist, H, P] = Copy_of_InsertANDdeletePoint(para, tempnew, nodelist, old_nodelist, input, output, ifGraph)
SampleNum = para.SamNum;
Dim = para.D;
FuncID = para.FuncID;
InsertPoint = [];
insertpointFV = [];
count = 0;
deletlist = [];
H = [];
P = [];
for TNi = 1 : length(tempnew)
    temppoint = tempnew(TNi);
    oldconnectpoint = old_nodelist(temppoint, 2);
    if ~isempty(find(old_nodelist(:, 2) == temppoint))
        if isempty(find(tempnew == oldconnectpoint))
            %%
            [PA, PB, PC, PE, minfit] = FindEndpoints(temppoint, oldconnectpoint, input, output, nodelist, old_nodelist);
            deletlist = [deletlist; output(temppoint), output(oldconnectpoint)];
            %%
            insertpoint = PrepareNewSample(PA, PB, PC, SampleNum, Dim);
            %%
            insertpointFVTemp = [];
            ifinsert = 1;
            for instI = 1 : length(insertpoint(:, 1))
                insertpointFVTemp(instI, 1) = fitness(insertpoint(instI, : ), para);
                %                 DE_programming_testFun(insertpoint(instI, : ), FuncID); % fitness evaluation??fitness_function(ttttt(instI, : ), para);
                if insertpointFVTemp(instI, 1) < minfit
                    ifinsert = 0;
                    break;
                end
            end
            count = count + length(insertpointFVTemp);
            %%
            if ifinsert
                InsertPoint = [InsertPoint; insertpoint];
                insertpointFV = [insertpointFV; insertpointFVTemp];
            end
            %             plot(ttttt(:, 1), ttttt(:, 2), 'kX', 'Markersize', 11);
            %%
            if ifGraph
                disconnectpoint = [input(temppoint, :); input(oldconnectpoint, :)];
                if Dim == 2
                    H(end + 1) = plot(disconnectpoint(:, 1), disconnectpoint(:, 2), 'rO', 'Markersize', 11);
                    P(end + 1) = plot(PC(:, 1), PC(:, 2), 'rS', 'Markersize', 11);
                    P(end + 1 : end + 1 + length(insertpoint(1 : instI, 1))) = plot(insertpoint(1 : instI, 1), insertpoint(1 : instI, 2), 'r.', 'Markersize', 30);
                elseif Dim == 1
                    fi = [output(temppoint, :); output(oldconnectpoint, :)];H = plot(disconnectpoint, fi, 'bX', 'Markersize', 13);
                    P(end + 1 : end + 1 + length(insertpoint(1 : instI, 1))) = plot(insertpoint(1 : instI, 1), insertpointFVTemp(1 : instI, 1), 'r.', 'Markersize', 15);
                end
            end
        end
    end
end