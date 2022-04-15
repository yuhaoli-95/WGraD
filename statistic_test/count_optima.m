% calculate the numben of found global optima by each algorithm
% save the result in 'Method.mat' file
clear all; clc;
all = [{'Switch1'}, {'Switch2'}, {'NBC2'}, {'WGraD1'}, {'WGraD2'}, {'Comb1'}, {'Comb2'}];%{'NBC2'}, {'WGraD1'}, {'WGraD2'}    , {'WGraD1'}, {'WGraD2'}
for Method = all
    AdressOneFunction(char(Method));
end
%%
function AdressOneFunction(Method)
for F = 1 : 8
    for D = [2 4 6 8 10 20]
        count = zeros(30, 1);
        NArray = zeros(30, 1);
        if F == 6 | F == 7
            if mod(D, 2)
                eval(['F', num2str(F), 'D', num2str(D) ' = count;']);
                eval(['NF', num2str(F), 'D', num2str(D) ' = NArray;']);
                disp(['Func', num2str(F), '_', num2str(D), 'D:  ' , num2str(mean(count)), '  N:  ' , num2str(mean(NArray))]);
                continue;
            end
        end
        %%
        for RepIth = 1 : 30
            % load output of niching algorithm
            filename = [Method, '/F', num2str(F, '%02d'), 'D', num2str(D, '%02d'), 'Run', num2str(RepIth, '%02d'), '.mat'];
            load(filename, 'BestIndi', 'CN');
            % calculate the numben of found global optima by each algorithm
            count(RepIth) = count_opti(BestIndi, F);
            % record result
            NArray(RepIth) = CN;
        end
        eval(['F', num2str(F), 'D', num2str(D) ' = count;']);
        eval(['NF', num2str(F), 'D', num2str(D) ' = NArray;']);
        disp(['Func', num2str(F), '_', num2str(D), 'D:  ' , num2str(mean(count)), '  N:  ' , num2str(mean(NArray))]);
    end
end
% save result
save([Method, '.mat']);
end

%%
function count = count_opti(X, F)
% calculate the numben of found global optima by each algorithm
% X: output of niche algorithm
% F: the index of benchmark function; the best fitness of the i-th benchmark function is (-i * 100) 
% addition: we minimize benchmark functions in out experiment
if isempty(X)
    count = 0;
    return;
end
XFitness = X(:, end);
X(XFitness < - F * 100 - 0.01, :) = [];
X = X(:, 1 : end - 1);
count = 0;
while X
    tempX = X(1, :);
    Xdistance = pdist2(tempX, X);
    X(Xdistance < 0.1, :) = [];
    count = count + 1;
end
end