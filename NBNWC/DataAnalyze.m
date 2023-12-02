clear all;close all;clc;
addpath('.\FitnessFunction\nichingFunction');%nea2-tables\nea2+
MethodName = 'Test2AP_DE_1_0.5_0.5_500DLHS_endcondition3';
foldername = [{['..\..\data\', MethodName, '\datfile']}];%{'..\data\nea2-tables\nea2+'}
AccauracyArray = [0.1 0.01 0.001 0.0001 0.00001];
FuncArray = [1 : 20];
global initial_flag; % the global flag used in test suite
for FIth = 1 : length(foldername)
    PRtotaldata = [];
    SRtotaldata = [];
    for accuracy = [0.1 0.01 0.001 0.0001 0.00001]
        %%
        clc
        disp(['name of method: ', char(foldername(FIth))]);disp(['accuracy: ', num2str(accuracy)]);
        PRFunc = zeros(20, 1);
        SRFunc = zeros(20, 1);
        PRSaveData = zeros(50, 20);
        SRSaveData = zeros(50, 20);
        for ProblemIth = FuncArray
            %%
            D = get_dimension(ProblemIth);
            nop = get_no_goptima(ProblemIth);
            PRtemp = zeros(50, 1);
            SRtemp = 0;
            AveFEs = zeros(50, 1);
            fprintf('Function ID: %03d,     # of global optima = %03d\n', ProblemIth, nop);
            for Runtime = 1 : 50
                %%
                initial_flag = 0;
                filename = [char(foldername(FIth)), '\problem', num2str(ProblemIth, '%03d'), 'run', num2str(Runtime, '%03d'), '.dat'];
                data = importdata(filename);
                if ~isempty(data)
                    pop = cellfun(@str2num, data.textdata(:, 1 : D));
                    popFT = cellfun(@str2num, data.textdata(:, D + 2));
                    [count, finalseeds] = count_goptima(pop, ProblemIth, accuracy);
                else
                    count = 0;
                end
                PRtemp(Runtime) = count / nop;
                if count == nop
                    SRtemp = SRtemp + 1;
                    %                     AveFEs(Runtime) = get_maxfes(ProblemIth);
                end
                fprintf('f_%02d, In the current population there are %03d global optima!     PR = %6f\n', ProblemIth, count, PRtemp(Runtime));
            end
            PRSaveData(:, ProblemIth) = PRtemp;
            PRFunc(ProblemIth) = mean(PRtemp);
            SRFunc(ProblemIth) = SRtemp / 50;
            fprintf('f_%02d, ave(PR) = %6f,    ave(SR) = %6f\n', ProblemIth, PRFunc(ProblemIth), SRFunc(ProblemIth));
            fprintf('----------------------------------------------------------------------------------\n\n');
        end
        for ProblemIth = FuncArray
            fprintf('f_%02d, --------------------------------------------------------- avg(PR) = %6f\n', ProblemIth, PRFunc(ProblemIth));
        end
        save([char(foldername), '\accuracy', num2str(accuracy), '.mat'], 'PRSaveData');
        PRtotaldata(:, end + 1) = PRFunc;
        SRtotaldata(:, end + 1) = SRFunc;
    end
    save([char(foldername), '\totaldata.mat'], 'PRtotaldata', 'SRtotaldata', 'AccauracyArray');
end
xlswrite([char(foldername), '\PRExcelFile-', MethodName,'.xlsx'], PRtotaldata);
xlswrite([char(foldername), '\SRExcelFile-', MethodName,'.xlsx'], SRtotaldata);