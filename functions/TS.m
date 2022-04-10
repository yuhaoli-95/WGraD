function SolIndex = TS(input, output, NP)
[SamNum, D] = size(input);
TSArray = zeros(SamNum, NP);
for SamNumIth = 1 : SamNum
    TempX = input(SamNumIth, :);
    TempF = output(SamNumIth);
    Dis = pdist2(TempX, input);
    [~, index] = sort(Dis, 'ascend');
    for NPjth = 1 : NP
        TempIndex = index(NPjth);
        if TempF < output(TempIndex)
            TSArray(SamNumIth, NPjth) = 1;
        end
    end
end
sumSol = sum(TSArray, 2);
[~, SolIndex] = find(sumSol' == 0);
end