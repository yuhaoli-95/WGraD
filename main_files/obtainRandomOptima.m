clear all; clc;
D_choose=[5,10,20;
    2,5,8;
    2,3,4;
    5,10,20;
    2,3,4;
    4,6,8;
    6,10,16;
    2,3,4;
    repmat([10 20 30], 7, 1)];
for FuncID = 1:8
    Para.Benchmark = 'cec15_nich_func';
    Para.FuncID = FuncID;
    for Dith = 1 : 3
        D = D_choose(FuncID, Dith);
        eval(['load ../../../data/optima/optima_positions_', num2str(FuncID), '_', num2str(D), 'D.txt']);
        eval(['optima = optima_positions_', num2str(FuncID), '_', num2str(D), 'D;']);
        eval(['F', num2str(FuncID), 'D', num2str(D), ' = optima;']);
        eval(['F', num2str(FuncID), 'D', num2str(D), 'fit = zeros(length(optima(:, 1)), 1);']);
        for ith = 1 : length(optima(:, 1))
            eval(['F', num2str(FuncID), 'D', num2str(D), 'fit(ith) = fitness(optima(ith, :), Para);']);
        end
    end
end
save('Randomn.mat');