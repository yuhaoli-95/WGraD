function para = get_para(FuncID, SampleNum, folder_name, randseed, gaussian)
para.randseed  = randseed;
para.Max_FEs   = get_maxfes(FuncID);
para.FuncID    = FuncID;
para.rho       = get_rho(FuncID);
para.lb        = get_lb(FuncID);
para.ub        = get_ub(FuncID);
para.D         = get_dimension(FuncID);
para.SamNum    = SampleNum;
para.no        = get_no_goptima(FuncID);
para.FName     = folder_name;
para.gaussian  = gaussian;
if gaussian
    para.ff_min = 0;
    para.ff_max = 100;
    para.D = 2;
    para.lb = para.ff_min * ones(1, para.D);
    para.ub = para.ff_max * ones(1, para.D);
end
end