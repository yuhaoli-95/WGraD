function para = generate_sampleing_point1(para, samples)
samplenum = para.SamNum;
anasysnum = para.SamNum;
Dim       = para.D;
lb        = para.lb;
ub        = para.ub;
%%
% count = 0;
% Sample = [];
% d = 20;
% Interval = (ub - lb) / d;
% BestPoint = [];
% SampPoint = [];
% while count < samplenum + 1
%     SamPoint(1, :) = lb + (ub - lb) .* rand(1, D);
%     SampFit(1, 1) = fitness(SamPoint(1, :), para); count = count + 1;
%     %
%     BaseVector = rand(1, D);
%     WarkVector = BaseVector / norm(BaseVector) .* Interval;
%     SamPoint(2, :) = WarkVector + SamPoint(1, :);
%     SampFit(2, 1) = fitness(SamPoint(2, :), para); count = count + 1;
%     %
%     while abs(SampFit(end) - SampFit(end - 1)) > 0.1
%         if SampFit(end) > SampFit(end - 1)
%             BaseVector = SamPoint(end, :) - SamPoint(end - 1, :);
%             StartPoint = SamPoint(end, :);
%         else
%             BaseVector = SamPoint(end - 1, :) - SamPoint(end, :);
%             StartPoint = SamPoint(end - 1, :);
%         end
%         WarkVector = BaseVector / norm(BaseVector) .* Interval;
%         SamPoint(end + 1, :) = StartPoint + WarkVector;
%         SampFit(end + 1, 1) = fitness(SamPoint(end, :), para); count = count + 1;
%     end
% end
%%
% if Dim == 1 | Dim == 2 | Dim == 3 | Dim == 5
%     NP = 50;
% elseif Dim == 10 | Dim == 20
%     NP = 100;
% end
% param.fitness_index    = para.FuncID;
% param.F                = 0.9;
% param.CR               = 1;
% param.mutationStrategy = 1;
% param.crossStrategy    = 1;
% param.Xmin             = lb;
% param.Xmax             = ub;
% Generation             = 1;
%
% for D = 1 : Dim
%     %     Samples(:, D) = lb(D) + (ub(D) - lb(D)) * rand(num, 1);
%     t = linspace(lb(D), ub(D), NP);
%     X(:, D) = t(randperm(length(t)));
% end
%
% for Npith = 1 : NP
%     %     X(Npith, :) = lb + (ub - lb) .* rand(1, Dim);
%     fitnessX(Npith, 1)= DE_programming_testFun(X(Npith, :), param.fitness_index);
% end
% SamPoint = X;
% SamPointFit = fitnessX;
% % hold on
% % plot3(X(:, 1), X(:, 2), fitnessX, '.', 'markersize', 25);
% while Generation < samplenum / NP
%     [fitnessbestX, indexbestX] = max(fitnessX);%fitnessbestX is the best fitness
%     bestX = X(indexbestX,:);%bestX is best solutation
%     %%
%     %step2:mutation
%     [M] = DE_programming_mutation(X, bestX, param);
%     %step2.2:crossover
%     [U] = DE_programming_crossover(X, M, param);
%     %step3:check border of offspring U
%     [U] = DE_programming_Cross_border_inspecte(U, param);
%     %%
%     for NPith = 1 : NP
%         if X(NPith, :) == U(NPith, :)
%             U(NPith, :) = lb + (ub - lb) .* rand(1, Dim);
%         end
%     end
%     %%
%     %step4:selection
%     [offspring, fitness_off, fitnessU] = Bio_Selction(X,U,fitnessX,fitnessbestX,bestX,param);
%     fitnessX = fitness_off;
%     X = offspring;
% %     plot3(U(:, 1), U(:, 2), fitnessU, '.', 'markersize', 25);
%     SamPoint = [SamPoint; U];
%     SamPointFit = [SamPointFit; fitnessU];
%     Generation = Generation + 1;
% end
%%
% NP = 10;
% for D = 1 : Dim
%     t = linspace(lb(D), ub(D), NP);
%     Samples(:, D) = t(randperm(length(t)));
% end
% for ith = 1 : NP
%     SampFit(ith, 1) = fitness(Samples(ith, :), para);
% end
% count = NP;
% while count < samplenum
%     X_test = [];
%     XtestFit =[];
% %     X_test = lb + (ub(D) - lb(D)) * rand(num, 1);
%     for D = 1 : Dim
%         t = linspace(lb(D), ub(D), NP * 10);
%         X_test(:, D) = t(randperm(length(t)));
%     end
%     gprMdl = fitrgp(Samples, SampFit, 'SigmaLowerBound', 0.2, 'Standardize', true);
%     [ymu, ys] = predict(gprMdl, X_test);
%     Temp = ymu + 3 * ys;
%     [~, index] = sort(Temp, 'descend');
%     X_test = X_test(index(1 : NP), :);
%     for ith = 1 : NP
%         XtestFit(ith, 1) = fitness(X_test(ith, :), para);
%     end
%     count = count + NP;
%     plot(X_test(:, 1), X_test(:, 2), '.', 'markersize', 15);
%     pause(0.01);
%     Samples = [Samples; X_test];
%     SampFit = [SampFit; XtestFit];
% end

%%
% Samples = zeros(samplenum, Dim);
% for D = 1 : Dim
%     %     Samples(:, D) = lb(D) + (ub(D) - lb(D)) * rand(num, 1);
%     t = linspace(lb(D), ub(D), samplenum);
%     Samples(:, D) = t(randperm(length(t)));
% end
%%
% SampleFitness = zeros(samplenum,1);
% for ith = 1 : samplenum
%     SampleFitness(ith) = fitness(Samples(ith, :), para);
% end
% [~, index] = sort(SampleFitness, 'descend');
% SampleFitness = SampleFitness(index(1 : anasysnum), :);
% Samples = Samples(index(1 : anasysnum), :);
para.AnalysisData = [SamPoint SamPointFit;];
end