function NewNetWork = spanningtree(nodelist)
TempSampleNum  = length(nodelist(:, 1));
NewNetWork = {[]};
Num = 1;
for i = 1 : TempSampleNum
    if sum(nodelist(i, :)) ~= 0 %~isempty(nodelist(i, :))
        t1 = nodelist(i, :);
        nodelist(i, :) = [0, 0];
        list = t1(1);
        if t1(1) == t1(2)
            temp = [];
        else
            temp = t1(2);
        end
        [~, node] = find(nodelist(:, 2)' == i);
        %delete node which connect to i. push these node into temp
        nodelist(node', :) = zeros(length(node), 2);
        temp = [temp node];
        temp = unique(temp);
        while ~isempty(temp)
            tempnode = temp(1);
            temp(1) = [];
            %Check tempnode. Push tempnode into list
            list = [list tempnode];
            %tempnode connect another sample. if this node ~= 0, push this
            %node into temp
            if nodelist(tempnode, 2) ~= 0
                temp = [temp nodelist(tempnode, 2)];
            end
            %delete tempnode
            nodelist(tempnode, :) = [0, 0];
            %%
            [~, node] = find(nodelist(:, 2)' == tempnode);
            temp = [temp node];
            temp = unique(temp);
        end
        list = unique(list);
        NewNetWork(Num) = {list};
        Num = Num + 1;
    end
end
end