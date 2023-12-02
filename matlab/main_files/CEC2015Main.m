clear all;close all;clc;
fullpath = mfilename('fullpath'); 
[folder, ~, ~] = fileparts(fullpath);
parentFolder = fileparts(folder);
addpath(genpath(parentFolder));
%%
data_file_name = './result/CEC2015'; CheckFolder(data_file_name);
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
for method = [{'Comb1'}, {'Comb2'}, {''}, {''}]%{'WGraD2'}, {'WGraD1'}, {'NBC2'}, {'Comb'}
    if ~isempty(char(method))
        FolderName = [data_file_name, '/', num2str(char(method))];
        for FID = 1 : 8
            Problem = ['cec15_nich_func', num2str(FID)];
            for D = [2,4,6,8,10, 20]
                lb = -100 * ones(1,D);
                ub = 100 * ones(1,D);
                MaxFes = 20000 * D;
                SampleNum = BaseSampleNum * D;
                for rep = 1 : randseed
                    Main_TwoStageNichingAlgorithm(Problem, lb, ub, D, MaxFes, method, SampleNum, Optimizer, FolderName, rep);
                end
            end
        end
    end
end