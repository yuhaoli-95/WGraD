function spiderniching(RepIth, FuncID, ifGraph, FolderName, SampleNum)
%% 
tic
warning off
global initial_flag
initial_flag = 0; % should set the flag to 0 for each run, each function
% set random seed
rng(RepIth);
% set file path
GraphName = [FolderName, '/FuncID', num2str(FuncID),'/']; checkFolder(GraphName);
DatFileFolderName = [FolderName, '\datfile\']; checkFolder(DatFileFolderName);
BestDatFileFolderName = [FolderName, '\Bestdatfile\']; checkFolder(BestDatFileFolderName);
checkFolder(FolderName);
%% 
TArray = [];
FArray = [];
fes = 0;
BestIndi = [];
ECArray = [];
while fes < get_maxfes(FuncID)
    [FArray, TArray, fes, BestIndi, ECArrayT] = spiderniching_onetime(RepIth, FuncID, ...
        ifGraph, FolderName, SampleNum, fes, BestIndi, FArray, TArray);
    ECArray = [ECArray ECArrayT];
end
t = toc;
BestIndiX = BestIndi(:, 1 : end - 1);
SolNum = length(BestIndiX(:, 1));
SaveDatFile(TArray, BestIndi, FArray, DatFileFolderName, FuncID, RepIth, get_dimension(FuncID));
%%
[count, ~] = count_goptima(BestIndiX, FuncID, 0.1);
[count2, ~] = count_goptima(BestIndiX, FuncID, 0.01);
[count3, ~] = count_goptima(BestIndiX, FuncID, 0.001);
[count4, ~] = count_goptima(BestIndiX, FuncID, 0.0001);
[count5, ~] = count_goptima(BestIndiX, FuncID, 0.00001);
no_glo = get_no_goptima(FuncID);
fprintf('f_%02d, rth: %02d, t: %04d, -- # of glo: %0.4f | %0.4f | %0.4f | %0.4f | %0.4f, -- F1: %0.2f | %0.2f | %0.2f | %0.2f | %0.2f\n', FuncID, RepIth, round(t), ...
    count / no_glo , count2 / no_glo, count3 / no_glo, count4 / no_glo, count5 / no_glo, count / SolNum , count2 / SolNum, count3 / SolNum, count4 / SolNum, count5 / SolNum);
save([GraphName, 'run', num2str(RepIth, '%03d'), 'MMOresult.mat']);
end