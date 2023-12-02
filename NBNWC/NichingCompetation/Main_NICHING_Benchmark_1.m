clear all;close all;clc;
fullpath = mfilename('fullpath'); 
[folder, ~, ~] = fileparts(fullpath);
parentFolder = fileparts(folder);
addpath(genpath(parentFolder));
if_sample   = 0;
ifGraph     = 0;
if_mesh     = 1;
randseed    = 4;
folder_name = [
    fullfile(parentFolder, 'result/Test3AP_DE_1_0.5_0.5_500DLHS_endcondition3')
];
for FuncID = [1 : 20]
    SampleNum = 500 * get_dimension(FuncID);%get_maxfes(FuncID) * percent; 
    for reputationIth = 1 : randseed
        spiderniching(reputationIth, FuncID, ifGraph, folder_name, SampleNum);
    end
end