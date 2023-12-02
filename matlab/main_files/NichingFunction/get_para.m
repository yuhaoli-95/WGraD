function para = get_para(FuncID, SampleNum, folder_name, randseed, Benchmark, D)
para.benchmark  = Benchmark;
para.randseed   = randseed;
para.FuncID     = FuncID;
para.SamNum     = SampleNum;
para.FName      = folder_name;
switch Benchmark
    case 'CEC2013'
        global initial_flag
        initial_flag = 0; % should set the flag to 0 for each run, each function
        para.Max_FEs   = get_maxfes(FuncID);
        para.rho       = get_rho(FuncID);
        para.lb        = get_lb(FuncID);
        para.ub        = get_ub(FuncID);
        para.D         = get_dimension(FuncID);
        para.no        = get_no_goptima(FuncID);
    case 'CEC2015'
        para.D         = D;
        [para.glo, para.loc] = return_num_of_opt(FuncID, D);
        para.Max_FEs   = 20000 * D;
        %         eval(['load ../FitnessFunction/cec15_nich_matlab_code/input_data/shift_data_' num2str(FuncID) '.txt']);
        %         eval(['para.Oshift=shift_data_' num2str(FuncID) '(1:D);']);
        %         eval(['load ../FitnessFunction/cec15_nich_matlab_code/input_data/M_' num2str(FuncID) '_D' num2str(D) '.txt']);
        %         eval(['para.M=M_' num2str(FuncID) '_D' num2str(D) ';']);
        %         eval(['load ../FitnessFunction/cec15_nich_matlab_code/optima/optima_positions_', num2str(FuncID), '_', num2str(D), 'D.txt']);
        %         eval(['para.optima = optima_positions_', num2str(FuncID), '_', num2str(D), 'D;']);
        para.lb = -100 * ones(1, D);
        para.ub = 100 * ones(1, D);
    case 'Gaussian'
        para.ff_min = 0;
        para.ff_max = 100;
        para.D = 2;
        para.lb = para.ff_min * ones(1, para.D);
        para.ub = para.ff_max * ones(1, para.D);
end
end