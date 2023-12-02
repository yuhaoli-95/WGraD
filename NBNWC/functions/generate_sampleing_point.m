function para = generate_sampleing_point(para, samples)
samplenum = para.SamNum;
anasysnum = para.SamNum;
Dim       = para.D;
lb        = para.lb;
ub        = para.ub;
%%
Samples = zeros(samplenum, Dim);
for D = 1 : Dim
    %     Samples(:, D) = lb(D) + (ub(D) - lb(D)) * rand(num, 1);
    t = linspace(lb(D), ub(D), samplenum);
    Samples(:, D) = t(randperm(length(t)));
end
SampleFitness = zeros(samplenum,1);
for ith = 1 : samplenum
    SampleFitness(ith) = fitness(Samples(ith, :), para);    
end
[~, index] = sort(SampleFitness, 'descend');
SampleFitness = SampleFitness(index(1 : anasysnum), :);
Samples = Samples(index(1 : anasysnum), :);
para.AnalysisData = [Samples SampleFitness;];
end