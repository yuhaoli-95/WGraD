function [BestIndiArray, fes, All] = ObtainMultipleOptima(BestIndiArray, fes, networkInfo, opti_para)
% obtian the local optima from different clusters; 
% input:
% BestIndiArray: best individuals array
% fes: fitness times
% networkInfo: clusters information
% opti_para: parameters of optimization method(DE/ CMA-ES)
%%
for ni = 1 : length(networkInfo)
    pop = opti_para.sampledata(cell2mat(networkInfo(ni)), :);
    ifhill = 0;
    if opti_para.CheckHill
        if ~isempty(BestIndiArray)
            [~, BestIndex] = max(pop(:, end));
            [ifhill, fes, ~] = HillValleyTest(BestIndiArray, pop(BestIndex, :), fes, opti_para);
        end
    end
    %% New hill
    if ~ifhill
        switch opti_para.name
            case 'DE'
                [fes, BestIndi, All] = DE(opti_para, pop, fes);
            case 'CMA-ES'
                [fes, BestIndi, All] = cmaes(opti_para, pop, fes);
        end
        %%
        BestIndiArray = [BestIndiArray; BestIndi];
        %         [BestIndiArray, fes] = CheckSolution(BestIndiArray, BestIndi, fes, opti_para);
        %         [BestIndiArray] = FliterAllSolution(BestIndiArray, 0.1);
    end
    %% Termination
%     if fes > opti_para.MaxFes
%         break;
%     end
end
end