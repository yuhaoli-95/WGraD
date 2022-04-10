function elite = EstimationApproximation(parents, offspring, popnum, genenum)
if length(parents(1, :)) ~= genenum
    error();
end
if length(parents(:, 1)) ~= popnum
    error();
end
if isempty(parents(1, :)) == 0
    iteration = 10;
    b_is_0 = zeros(popnum, 1);
    %%
    %step 1: elite is the point that the average of offspring
    elite = mean(offspring, 1);%obtain elite
    b = offspring - parents;%obtain moving vector bi
    norm = sum(b.^2, 2);%calculate bi * biT
    b_is_0(norm ~= 0) = 1;%if b = [0,0,0,...,0]
    %%
    %step 2
    yy = zeros(popnum, genenum);
    for iter=1:iteration
        for i = 1 : popnum
            numerator = b(i, :) .* (elite - parents(i, :));
            numerator = sum(numerator);
            if b_is_0(i) == 1
                t = numerator / (norm(i));
                yy(i, :) = parents(i, :) + t .* b(i, :);
            end
        end
        %%
        %step 3
        elite = mean(yy(b_is_0 == 1, :), 1);
        if isempty(elite)
            elite = zeros(1, genrnum);
        end
    end
else
    elite = zeros(1, genrnum);
end

end