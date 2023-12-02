function [fesArray, TArray, fes, BestIndiArray, ECArray] = spiderniching_onetime(n, FuncID, ifGraph, FolderName, SampleNum, fes, BestIndiArray, fesArray, TArray)
% This function is the main function of optimization algorithm and it
% returns the best solution obtained during this run. 
% Firstly, it samples the solution space and then clusters the sample points to obtain different classes using NBNWC. 
% And then it optimizes different clusters individually. This step can be performed using either the DE algorithm or the CMA-ES algorithm. 
% The algorithm terminates when the stop condition is met.
%%
% Input:
%   n: random seed; index of "for" loop
%   FuncID: cec2013 function id
%   ifGraph: 
%   FolderName: set the path for saving the results
%   SampleNum: number of sample
%   fes: remained fitness function evaluation times
%   BestIndiArray: current found best individual
%   fesArray: record the number of fitness function usage for each best solution
%   TArray: record the time of fitness function usage for each best solution
% Output:
%   fesArray: updated the number of fitness function usage for each best solution
%   TArray: updated the time of fitness function usage for each best solution
%   fes: updated the remained fitness function evaluation times
%   BestIndiArray: updated found best individual
%   ECArray: record the stop condition triggered each time
%% get parameters
tic
NWPara = get_para(FuncID, SampleNum, FolderName, n, 0);
NWPara = generate_sampleing_point(NWPara);%sampling:(1*Dim)parameter | (Dim+1)fitness  sampledata  testdata
%% cluster samples
[networkInfo, NWPara] = ApproximationNetworkAnalyze(NWPara, ifGraph);
fes = fes + NWPara.FEs + SampleNum;
%% Each cluster(connected point) is treated as the initial solution.
remainFEs = floor((get_maxfes(FuncID) - fes) / length(networkInfo));
ECArray = [];
t = 1;
LoModal(t).lb = [];
LoModal(t).ub = [];
LoModal(t).model = [];
for NWith = 1 : length(networkInfo)
    tempnew = cell2mat(networkInfo(NWith));
    % pop: [[x1, x2, ..., xn, y] * m], m * (n + 1)
    % m: # of population, n: # of variable
    pop = NWPara.sampledata(tempnew, :);
    ifhill = 0;
    if ~isempty(BestIndiArray)
        [~, BestIndex] = max(pop(:, end));
        % Check if a new "hill" with the optimal solution has been found.
        [ifhill, fes, ~] = HillValleyTest(BestIndiArray, pop(BestIndex, :), fes, FuncID);
    end
    %% New hill
    if ~ifhill
        %% differential evolution
        lb = min(pop(:, 1 : end - 1));
        ub = max(pop(:, 1 : end - 1));
        [DEpara, pop, fes] = get_DEParame(remainFEs, pop, FuncID, lb, ub, fes);
        [fes, BestIndi, ECArray(end + 1), model] = DE_Programming(DEpara, pop, LoModal, fes);
        %%
        LoModal(t).lb = lb;
        LoModal(t).ub = ub;
        LoModal(t).model = model;
        LoModal(t).bestso = BestIndi;
        t = t + 1;
        %%
        %     BestIndiArray = [BestIndiArray; BestIndi];
        %     NP = length(BestIndi(:, 1));
        %     fesArray(end + 1 : end + NP) = fes * ones(NP, 1);
        %     TArray(end + 1 : end + NP) = toc * ones(NP, 1);
        [BestIndiArray, fes, fesArray, TArray] = CheckSolution(BestIndiArray, BestIndi, fes, FuncID, fesArray, TArray);
        [BestIndiArray, fesArray, TArray] = check_all_solution(BestIndiArray, 0.1, fesArray, TArray);
    end
    if fes > get_maxfes(FuncID)
        break;
    end
end
end