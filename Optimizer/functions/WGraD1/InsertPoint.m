function [InsertPoint, InsertPointF, count, merge] = InsertPoint(para, tempnew, nodelist, old_nodelist, input, output)
Dim = length(input(1, :));
InsertPoint = [];
InsertPointF = [];
count = 0;
merge = [];
for TNi = 1 : length(tempnew)
    temppoint = tempnew(TNi);
    oldconnectpoint = old_nodelist(temppoint, 2);
    if ~isempty(find(old_nodelist(:, 2) == temppoint))
        if isempty(find(tempnew == oldconnectpoint))
            %%
            [PA, PB, PC, PE, minfit, PAIndex, PBIndex] = FindEndpoints(temppoint, oldconnectpoint, input, output, nodelist, old_nodelist);
            %%
            insertpoint = PrepareNewSample(PA, PB, PC, Dim);
            %%
            insert_point_fit = [];
            ifinsert = 1;
            for instI = 1 : length(insertpoint(:, 1))
                insert_point_fit(instI, 1) = fitness(insertpoint(instI, : ), para);
                if insert_point_fit(instI, 1) < minfit
                    ifinsert = 0;
                    break;
                end
            end
            count = count + length(insert_point_fit);
            %%
            if ifinsert
                InsertPoint = [InsertPoint; insertpoint];
                InsertPointF = [InsertPointF; insert_point_fit];
                merge(end + 1, :) = [PBIndex PAIndex];
            end
        end
    end
end