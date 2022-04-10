function [Ind, IndFit, fes] = ES(X, XFit, Cluster, sigma, Taboo, NP, Para, fes, Dim, MaxEva)
GMax = 50;
tolerance = 10^-8;
CN = length(Cluster);
Center = zeros(CN, Dim);
CenterFit = zeros(CN, 1);
indexbestX = zeros(CN, 1);
Stop = zeros(CN, 1);
% cov_sigma = diag(ones(1, Dim) * sigma);
improvement = cell(CN, 1);
Pop = cell(CN, 1);
for Ci = 1 : length(Cluster)
    TempNode = cell2mat(Cluster(Ci));
    [CenterFit(Ci), indexbestX(Ci)] = max(XFit(TempNode));%fitnessbestX is the best fitness
    Center(Ci, :) = X(TempNode(indexbestX(Ci)), :);%bestX is best solutation
    Pop(Ci) = {X(TempNode, :)};
end
%% search local optima
while ~all(Stop)
    %% generate offspring
    for i = 1 : CN
        if Stop(i)
            continue;
        end
                PX(i) = plot(Center(i, 1), Center(i, 2), 'ro');
        %generate offspring
        cov_center = cov(cell2mat(Pop(i)));
        temp = mvnrnd(Center(i, :), cov_center, NP);
        Pop(i) = {temp};
        tempFit = zeros(NP, 1);
        for ith = 1 : NP
            tempFit(ith) = fitness(temp(ith, :), Para);
        end
        fes = fes + NP;
        if fes > MaxEva
            break;
        end
        [MaxFit, MaxIndex] = max(tempFit);
        %update center and fitenss
        TempImpr = cell2mat(improvement(i));
        TempImpr(end + 1) = MaxFit - CenterFit(i);
        improvement(i) = {TempImpr};
        if MaxFit > CenterFit(i)
            Center(i, :) = temp(MaxIndex, :);
            CenterFit(i) = MaxFit;
        end
                PO(i) = plot(Center(i, 1), Center(i, 2), 'bo');
        %convergence check
        if length(TempImpr) > GMax
            if TempImpr(end - GMax + 1 : end) < tolerance%end - GMax + 1 : end
                Stop(i) = 1;
            end
        end
    end
        pause(0.1);
        delete(PX);
        delete(PO);
    if fes > MaxEva
        break;
    end
    %% check taboo
    if ~isempty(Taboo)
        DisGraph = pdist2(Taboo, Center);
        for i = 1 : length(Taboo(:, 1))
            TempDisGraph = DisGraph(i, :);
            [a, index] = find(TempDisGraph <= 2 * sigma);
            Stop(index) = 1;
        end
    end
    %% check overlop
    DisGraph = pdist2(Center, Center);
    for i = 1 : CN
        if Stop(i)
            continue;
        end
        TempDisGraph = DisGraph(i, :);
        TempDisGraph(i) = nan;
        [a, index] = find(TempDisGraph <= 2 * sigma);
        if ~isempty(index)
            a = 1;
        end
        Stop(index) = 1;
    end
end
Ind = Center;
IndFit = CenterFit;
end