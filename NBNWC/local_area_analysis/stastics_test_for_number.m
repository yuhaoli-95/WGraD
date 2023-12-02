close all;clear all; clc;
method = {'NBC2'; 'approximation'; 'proDRankGvalue'};
%%
%data address
% for methith = 1 : length(method)
%     data = [];
%     for funct = 1 : 20
%         for rep = 1 : 50
%             foldername = ['.\', char(method(methith)), '\'];
%             filename = [foldername, 'FuncID', num2str(funct), '\run', num2str(rep, '%03d'), 'ClusteringResult.mat'];
%             networkInfo = load(filename, 'networkInfo');
%             data(rep, funct) = length(networkInfo.networkInfo);
%         end
%     end
%     save([foldername, char(method(methith)), '_networkinfo.mat'], 'data');
% end
%%
numpro = length(method);
row_num = nchoosek(1 : numpro, 2);

NBC2 = load('.\NBC2\NBC2_networkinfo.mat', 'data');
approximation = load('.\approximation\approximation_networkinfo.mat', 'data');
proDRankGvalue = load('.\proDRankGvalue\proDRankGvalue_networkinfo.mat', 'data');
NBC2 = NBC2.data;
approximation = approximation.data;
proDRankGvalue = proDRankGvalue.data;

data = NBC2;
data(:,:, 2) = approximation;
data(:,:, 3) = proDRankGvalue;
ave = mean(data);
SiLvel = 0.01;
result = {};
averesult = [];
for func = 1 : 20
    temp = reshape(ave(:, func, :), 1, numpro);
    [averesult(func, :), index] = sort(temp);
    compare(1, index) = method;
    tempresult = method(index(1));
    for ci = 1 : numpro - 1
        t1 = data(:, func, index(ci));
        t2 = data(:, func, index(ci + 1));
        p = signrank(t1, t2);
        if p < SiLvel / numpro
            tempresult = [tempresult, {'<<'}];
        else
            tempresult = [tempresult, {'='}];
        end
        tempresult = [tempresult, method(index(ci + 1))];
    end
    result(func, :) = tempresult;
end




