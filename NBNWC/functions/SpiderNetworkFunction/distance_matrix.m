function distance_matrix(x, FuncID, runtime)
[NP, ~] = size(x);
filename = ['F:\CEC2013DistanceDATA\Func', num2str(FuncID)];
checkFolder(filename, filename, filename);
empity = [];
save([filename, '\run', num2str(runtime), '.mat'], 'empity');
for SIth = 1 : NP
    Str = ['s', num2str(SIth)];
    eval([Str, '=', 'sqrt(sum((repmat(x(SIth, :), NP, 1) - x) .^ 2, 2))', ''';']);
    save([filename, '\run', num2str(runtime), '.mat'], Str, '-append');
    eval(['clear ', Str, ';']);
end
% for SIth = 1 : NP
%     Str = ['s', num2str(SIth)];
%     load([filename, '\run', num2str(runtime), '.mat'], Str);
%     eval(['temp = ', Str, ';']);
%     if sum(temp - disTemp(SIth, :))
%         aaaaa = 1;
%     end
%     eval(['clear ', Str, ';']);
% end
end