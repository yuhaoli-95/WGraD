clear all;close all;clc;
addpath(genpath('..\..\original_with_iteration'));
if_sample   = 0;
ifGraph     = 1;
times       = 1;
if_mesh     = 0;
randseed    = 50;
method      = 'proDRankGvalue';
gaussian    = 1;
for FuncID = 5
    for reputationIth = 1 : randseed
        local_area_segmentation(reputationIth, FuncID, times, method, gaussian);
    end
end