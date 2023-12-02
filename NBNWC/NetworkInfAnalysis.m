clear all;close all;clc;
addpath('.\FitnessFunction\nichingFunction');
foldername = '..\data\SpiderCDE_DrankGvalue\rand-best\0.5Times_0.1FEsMAX\';%{'..\data\nea2-tables\nea2+'}
FuncArray = [1 : 12];
NetwoekInfo = [];
disp(['name of method: ', foldername]);
NIFuncAve = zeros(20, 2);
NISaveData = zeros(50, 20);
for ProblemIth = FuncArray
    %%
    NItemp = zeros(50, 1);
    SRtemp = 0;
    fprintf('Function ID: %03d,     # of global optima = %03d\n', ProblemIth, get_no_goptima(ProblemIth));
    for Runtime = 2 : 50
        %%
        %run001MMOresult.mat
        filename = [foldername, 'FuncID', num2str(ProblemIth), '\run', num2str(Runtime, '%03d'), 'MMOresult.mat'];
        data = load(filename);
        NItemp(Runtime) = length(data.networkInfo);
        fprintf('f_%02d, In the current population there are %03d networks!\n', ProblemIth, NItemp(Runtime));
    end
    NISaveData(:, ProblemIth) = NItemp;
    NIFuncAve(ProblemIth, :) = [mean(NItemp) var(NItemp)];
    fprintf('f_%02d, ave(network) = %6f, var=(network) = %6f\n', ProblemIth, NIFuncAve(ProblemIth, 1), NIFuncAve(ProblemIth, 2));
    fprintf('----------------------------------------------------------------------------------\n\n');
end
for ProblemIth = FuncArray
    fprintf('f_%02d, ------------- ave(network) = %6f, var=(network) = %6f\n', ProblemIth, NIFuncAve(ProblemIth, 1), NIFuncAve(ProblemIth, 2));
end
save([foldername, 'data\NetworkInf.mat'], 'NISaveData');
xlswrite([char(foldername), 'data\NetworkInf.xlsx'], NIFuncAve);