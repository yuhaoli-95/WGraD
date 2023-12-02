function [InsertPoint, insertpointFV, count, deletlist, H, P] = InsertPoint(para, tempnew, nodelist, old_nodelist, input, output, ifGraph)
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
    if isempty(find(tempnew == oldconnectpoint))
        %%
        %maxmizetion problem
        if output(temppoint) > output(oldconnectpoint)
            PAIndex = temppoint;
            PBIndex = oldconnectpoint;
            PA = input(PAIndex, :);
            PB = input(PBIndex, :);
            PCIndex = nodelist(PBIndex, 2);
            PC = input(PCIndex, :);
            PEIndex = old_nodelist(PAIndex, 2);
            PE = input(PEIndex, :);
            minfit = output(oldconnectpoint);
        else
            PAIndex = oldconnectpoint;
            PBIndex = temppoint;
            PA = input(PAIndex, :);
            PB = input(PBIndex, :);
            PCIndex = nodelist(PBIndex, 2);
            PC = input(PCIndex, :);
            PEIndex = old_nodelist(PAIndex, 2);
            PE = input(PEIndex, :);
            minfit = output(temppoint);
        end
        %%
        %         lb = min([PA; PB]);
        %         ub = max([PA; PB]);
        %         Dim = length(lb);
        %         num = 10;
        %         for D = 1 : Dim
        %             %     Samples(:, D) = lb(D) + (ub(D) - lb(D)) * rand(num, 1);
        %             t = linspace(lb(D), ub(D), num);
        %             insertpoint1(:, D) = t(randperm(length(t)));
        %         end
        %         for numith = 1 : num
        %             insertpointFVTemp1(numith, 1) = -1 * DE_programming_testFun(insertpoint1(numith, : ), para.FuncID); % fitness evaluation??fitness_function(ttttt(instI, : ), para);
        %         end
        %%
        %         num = 10;
        %         for numith = 1 : num
        %             weight = rand(4, 1);
        %             weight = weight / sum(weight);
        %             Sparks = [PA; PB; PC; PE];
        %             insertpoint1(numith, :) = sum(Sparks .* repmat((weight), 1, Dim), 1);
        %             insertpointFVTemp1(numith, 1) = -1 * DE_programming_testFun(insertpoint1(numith, : ), FuncID); % fitness evaluation??fitness_function(ttttt(instI, : ), para);
        %         end
        %%
        %         deletlist(end + 1, 1) = PCIndex;
        %         disBA = sqrt(sum((PA - PB).^2));
        %         num = 11;
        %         VecBA = (PA - PB) / num;
        %         InsertVec = repmat(VecBA, num - 1, 1) .* repmat([1 : num - 1]', 1, para.Dim);
        %         insertpoint2 = InsertVec + repmat(PB, num - 1, 1);
        %         insertpointFVTemp2 = [];
        %         for instI = 1 : length(insertpoint2(:, 1))
        %             insertpointFVTemp2(instI, 1) = -1 * DE_programming_testFun(insertpoint2(instI, : ), FuncID); % fitness evaluation??fitness_function(ttttt(instI, : ), para);
        %         end
        %         InsertPoint = [InsertPoint; insertpoint2];%; insertpoint1];
        %         insertpointFV = [insertpointFV; insertpointFVTemp2];%; insertpointFVTemp1];
        %         count = count + length(insertpointFVTemp2);% + length(insertpointFVTemp1);
        %%
        disBA = sqrt(sum((PA - PB).^2));
        VecBA = (PA - PB) / disBA;
        halfdisBC = sqrt(sum((PC - PB).^2)) / 2;
        VecBD = VecBA * halfdisBC;
        InsertNum = floor(disBA / (halfdisBC));
        if halfdisBC < disBA & InsertNum < SampleNum
            InsertVec = repmat(VecBD, InsertNum, 1) .* repmat([1 : InsertNum]', 1, Dim);
            insertpoint = InsertVec + repmat(PB, InsertNum, 1);
        else
            num = 3;
            VecBA = (PA - PB) / num;
            InsertVec = repmat(VecBA, num - 1, 1) .* repmat([1 : num - 1]', 1, Dim);
            insertpoint = InsertVec + repmat(PB, num - 1, 1);
        end
        %%
        insertpointFVTemp = [];
        for instI = 1 : length(insertpoint(:, 1))
            insertpointFVTemp(instI, 1) = -1 * DE_programming_testFun(insertpoint(instI, : ), FuncID); % fitness evaluation??fitness_function(ttttt(instI, : ), para);
        end
        count = count + length(insertpointFVTemp);
        %%
        InsertPoint = [InsertPoint; insertpoint];
        insertpointFV = [insertpointFV; insertpointFVTemp];
        %             plot(ttttt(:, 1), ttttt(:, 2), 'kX', 'Markersize', 11);
        %%
        if ifGraph
            disconnectpoint = [input(temppoint, :); input(oldconnectpoint, :)];
            if para.Dim == 2
                H(end + 1) = plot(disconnectpoint(:, 1), disconnectpoint(:, 2), 'rO', 'Markersize', 11);
                P(end + 1) = plot(PC(:, 1), PC(:, 2), 'rS', 'Markersize', 11);
                P(end + 1 : end + 1 + length(InsertPoint(:, 1))) = plot(InsertPoint(:, 1), InsertPoint(:, 2), 'kX', 'Markersize', 11);
            elseif para.Dim == 1
                %                 fi = [output(temppoint, :); output(oldconnectpoint, :)];plot(disconnectpoint, fi, 'bX', 'Markersize', 13);
            end
        end
    end
end