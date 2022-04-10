clear all;close all;clc;
addpath(genpath('../../TwoStageNichingAlgorithm'));
%%
data_file_name = './result/CEC2013'; CheckFolder(data_file_name);
% diary([data_file_name, '\experiment_condition.txt']); %The file path and file name.
% diary on;
randseed = 30
Optimizer = 'DE' %CMA-ES    DE
LowBoundary = -100
UpperBoundary = 100
BaseMaxFes = 20000
BaseSampleNum = 200
% diary off;
%%
for method = [{''}, {'NBC2'}, {''}, {''}]%{'WGraD2'}, {'WGraD1'}, {'NBC2'}, {'Comb'}
    if ~isempty(char(method))
        FolderName = [data_file_name, '/', num2str(char(method))];
        for FID = 1 : 20
            Problem = ['cec13_nich_func', num2str(FID)];
            D = get_dimension(FID);
            lb = get_lb(FID);
            ub = get_ub(FID);
            MaxFes = get_maxfes(FID);
            SampleNum = BaseSampleNum * D;
            for rep = 1 : randseed
                Main_TwoStageNichingAlgorithm(Problem, lb, ub, D, MaxFes, method, SampleNum, Optimizer, FolderName, rep);
            end
        end
    end
end