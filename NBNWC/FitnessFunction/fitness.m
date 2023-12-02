function y = fitness(x, para)
FuncID = para.FuncID;
if para.gaussian
    y = Gaussian_Function(x, FuncID, para.ff_min, para.ff_max);
else
    y = niching_func(x, FuncID);
end
end