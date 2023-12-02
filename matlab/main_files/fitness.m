function y = fitness(x, para)
switch para.Benchmark
    case 'step1'
        y = -1 * step1(x);
    case 'step1_new'
        y = -1 * step1_new(x);
    case 'cec15_nich_func'
        y = -1 * cec15_nich_func(x', para.FuncID);
    case 'cec13_nich_func'
        y = niching_func(x, para.FuncID);
    case 'Gaussian'
        r = 0.207106781186547524400844362105 * 100;
        Sigma = [r ^ 2 0; 0 r ^ 2];
        y = 0;
        mu = [-0.292893218813452475599155637895  -0.292893218813452475599155637895;
            0.292893218813452475599155637895  -0.292893218813452475599155637895;
            0.000000000000000000000000000000   0.000000000000000000000000000000;
            -0.292893218813452475599155637895   0.292893218813452475599155637895;
            0.292893218813452475599155637895   0.292893218813452475599155637895;];
        mu = mu * 200;
        for i = 1 : 5
            y = y + mvnpdf(x, mu(i, :), Sigma);
        end
end
end