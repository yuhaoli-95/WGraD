function NewNetWork = ConnectNetWork(nodelist)
% find connected sub-graph using bfs(Breath First Search)
% input: [i-th sample index, the connected sample index]
% output: [[sample indices of j-th sub-graph ]]
%% 
TempSampleNum  = length(nodelist(:, 1));
NewNetWork = {[]};
Num = 1;
for i = 1 : TempSampleNum
    % if sum(nodelist(i, :)) == 0 means the i-th sample has been viewed
    if sum(nodelist(i, :)) ~= 0 %~isempty(nodelist(i, :))
        % find connected sub-graph using BFS from the i-th sample
        t1 = nodelist(i, :);
        % reset the i-th sample info, means it is viewed
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
for i = 1 : length(NewNetWork)
    TempNetWork = cell2mat(NewNetWork(i));
    TempNetWork = unique(TempNetWork);
    NewNetWork(i) = {TempNetWork};
end
end