function NewNetWork = ConnectNetWork(nodelist)
TempSampleNum  = length(nodelist(:, 1));
NewNetWork = {[]};
Num = 1;
for i = 1 : TempSampleNum
    if sum(nodelist(i, :)) ~= 0 %~isempty(nodelist(i, :))
        t1 = nodelist(i, :);
        nodelist(i, :) = [0, 0];
        NewNetWork(Num) = {t1};
        count = 0;
        while count ~= TempSampleNum - i
            count = 0;
            for j = i + 1 : TempSampleNum
                if sum(nodelist(j, :)) ~= 0 %~isempty(nodelist(j, :))
                    tempnode = nodelist(j, :);
                    if ~isempty(intersect(t1, tempnode))
                        nodelist(j, :) = [0, 0];
                        NewNetWork(Num) = {[t1, tempnode]};
                        t1 = [t1, tempnode];
                    else
                        count = count + 1;
                    end
                else
                    count = count + 1;
                end                
            end
        end        
        Num = Num + 1;
    end
end
NewNetWork(cellfun(@isempty,NewNetWork))=[];
i = 1;
NodeNum = zeros(length(NewNetWork), 1);
for i = 1 : length(NewNetWork)
    TempNetWork = cell2mat(NewNetWork(i));
    TempNetWork = unique(TempNetWork);
    TempNetWork(TempNetWork == -1) = [];
    TempNetWork = sort(TempNetWork);
    NodeNum(i) = length(TempNetWork);
    NewNetWork(i) = {TempNetWork};
end
[~, Order] = sort(NodeNum);
NewNetWork = NewNetWork(Order);
end